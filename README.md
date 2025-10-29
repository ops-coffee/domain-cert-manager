# 🛡️ 域名证书管理系统

## 📌 项目简介
域名证书管理系统是一个让企业轻松管理域名与 SSL/TLS 证书的集中化平台，支持证书生命周期管理、到期提醒、DNS 验证、可视化监控与团队协同，有效降低证书过期导致的服务中断和安全风险。

---

## ✨ 主要功能特性
| 类别 | 特性内容 |
|------|---------|
| ✅ 证书管理 | 自动跟踪证书有效期、签发机构、加密算法等信息 |
| ✅ 域名管理 | 域名统一收纳、状态标记、DNS 解析辅助管理 |
| ✅ 告警提醒 | 多渠道通知：邮件 / Webhook / 飞书 / 企业微信 / 钉钉 |
| ✅ 可视化监控 | 带筛选功能的可视化仪表盘 |
| ✅ 权限控制 | 团队协作、角色权限、组织分组管理 |
| ✅ 部署灵活 | 支持 Docker / 私有化部署 / 云环境 |

## 🚀 快速开始

1. 安装docker compose

```
curl -fsSL https://get.docker.com -o get-docker.sh | sudo sh
```

新版本docker已经默认安装了docker compose无需额外安装

```
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

2. 拉取deploy部署代码

```
mkdir domain-cert-manager && cd domain-cert-manager
git clone git@github.com:ops-coffee/domain-cert-manager.git
```

3. 启动docker compose

```
docker-compose up -d
```

4. 浏览器访问：`https://ip_or_domain:8001`

默认为8001端口，首次部署有数据初始化等操作，大约会占用几分钟时间，需等待完全启动后访问，可通过查看`ops-app`容器日志，输出`Start ok. ^_^`后表示启动完成

```
# docker logs ops-app -n 10
👤 创建管理员账号...
🚀 启动服务...
Starting supervisor: supervisord.
Mon Oct 27 18:57:31 CST 2025 ✅ Start ok. ^_^
```

5. 登录账号密码
   - 账号：admin@ops-coffee.com
   - 密码：ops-coffee.com

## ❓ 常见问题

1. MySQL/Redis 报错连不上，这个原因主要有两个：

   1. 服务启动失败，可能机器上已经部署过mysql等服务，导致docker compose再启动对应服务时，启动失败。所以推荐在干净的环境下部署

   2. docker网络异常，docker compose通过自定义的桥接网络进行连接，docker网络异常会导致连接失败

