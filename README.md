# 環境構築手順

## Docker Compose

```
docker-compose up -d
docker-compose exec web rails db:create db:schema:load
```