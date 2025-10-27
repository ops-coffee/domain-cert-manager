#!/bin/bash
set -e

# 等待 MySQL 启动就绪
echo "⏳ Waiting for MySQL to be ready..."
until mysqladmin ping -h "ops-mysql" --silent; do
    echo "⏱  MySQL is unavailable - retrying in 2s"
    sleep 2
done
echo "✅ MySQL is ready!"

# 等待 Redis 启动就绪
echo "⏳ Waiting for Redis to be ready..."
until redis-cli -h "ops-redis" ping | grep PONG > /dev/null; do
    echo "⏱  Redis is unavailable - retrying in 2s"
    sleep 2
done
echo "✅ Redis is ready!"

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
        password='ops-coffee.com'
    )
" || { echo >&2 "创建管理员失败"; exit 1; }

# 启动应用服务
echo "🚀 启动服务..."
cp supervisor.conf /etc/supervisor/conf.d/devops.conf || \
{ echo >&2 "An error occurred. Aborting."; exit 1; }

mkdir -p /home/logs
/etc/init.d/supervisor start

echo "$(date) ✅ Start ok. ^_^"
