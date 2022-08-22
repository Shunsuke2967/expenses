FROM nginx:1.15.8

# インクルード用のディレクトリ内を削除
RUN rm -f /etc/nginx/conf.d/*

# Nginxの設定ファイルをコンテナにコピー
ADD nginx.conf /etc/nginx/myapp.conf
ADD fullchain.pem /etc/letsencrypt/live/expenses.fukushun.com/fullchain.pem
ADD privkey.pem /etc/letsencrypt/live/expenses.fukushun.com/privkey.pem

# ビルド完了後にNginxを起動
CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/myapp.conf
