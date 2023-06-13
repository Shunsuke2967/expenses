# 環境構築手順

## Docker Compose

```
docker-compose up -d
docker-compose exec web yarn install
docker-compose exec web webpack:install
docker-compose exec web rails db:create db:schema:load
```

# リリース環境

## 使用ライブラリ/環境
- CentOS8
- Rails7.0.4
- Ruby3.2.1
- jQuery
- Chartkick
- Docker(開発環境用)
- Nginx

# アクセスURL
- https://expenses.fukushun.com/
