#!/bin/bash
set -e

MAX_RETRIES=30
SLEEP_INTERVAL=5

wait_for_db() {
    echo "⏳ 等待数据库 172.22.0.2:3306 就绪..."

    for i in $(seq 1 $MAX_RETRIES); do
        # 使用 Python 检查数据库连接（无需 mysql 客户端）
        if python3 << END
import sys
import pymysql

try:
    conn = pymysql.connect(
        host="172.22.0.2",
        port=3306,
        user="code_devops",
        password="ops-coffee",
        database="domain",
        connect_timeout=10
    )
    conn.close()
    print("✅ 数据库连接成功")
    sys.exit(0)
except Exception as e:
    print(f"❌ 连接失败: {e}")
    sys.exit(1)
END
        then
            return 0
        else
            echo "🔁 第 $i 次尝试失败，${SLEEP_INTERVAL} 秒后重试..."
            sleep $SLEEP_INTERVAL
        fi
    done

    echo "❌ 数据库连接超时，已重试 $MAX_RETRIES 次。"
    exit 1
}

# 等待数据库
wait_for_db

# 初始化数据库及静态资源
echo "⚙️ Running Django migrations & collectstatic..."

python3 manage.py collectstatic --noinput
python3 manage.py makemigrations --noinput || true
python3 manage.py migrate || { echo >&2 "migrate failed. Aborting."; exit 1; }

# 创建管理员账号
echo "👤 创建管理员账号..."
python3 manage.py shell -c "
from django.contrib.auth import get_user_model;
User = get_user_model();
if User.objects.filter(username='admin@ops-coffee.com').exists():
    print('管理员已存在')
else:
    User.objects.create_superuser(
        username='admin@ops-coffee.com',
        password='ops-coffee.com',
        mfa_enable=False,
    )
" || { echo >&2 "创建管理员失败"; exit 1; }

# 启动应用服务
echo "🚀 启动服务..."
cp supervisor.conf /etc/supervisor/conf.d/devops.conf || \
{ echo >&2 "An error occurred. Aborting."; exit 1; }

mkdir -p /home/logs
/etc/init.d/supervisor start

echo "$(date) ✅ Start ok. ^_^"
