# 設定ファイルの読み込み
. ./.env

# adminerのインストール
docker-compose exec wordpress bash -c "cd /var/www/html && curl -O https://www.adminer.org/static/download/4.7.3/adminer-4.7.3-en.php"
# wp-config.phpの生成
#docker-compose exec wordpress rm /var/www/html/wp-config.php
#docker-compose exec wordpress wp --allow-root core config --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD
# wordpressのインストール
docker-compose exec wordpress wp --allow-root core install --url=https://localhost --title=sitename --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL
# 日本語化&タイムゾーン設定
docker-compose exec wordpress wp --allow-root plugin install wp-multibyte-patch --activate
docker-compose exec wordpress wp --allow-root language core install ja
docker-compose exec wordpress wp --allow-root language core activate ja
docker-compose exec wordpress wp --allow-root option update timezone_string "Asia/Tokyo"
docker-compose exec wordpress wp --allow-root option update date_format 'Y年n月j日'
# よく使うプラグインのインストール&アクティベート
docker-compose exec wordpress wp --allow-root plugin install wordpress-importer mw-wp-form duplicate-post advanced-custom-fields --activate
# understrapとunderstrap-childのインストール&アクディベート
docker-compose exec wordpress wp --allow-root theme install understrap
docker-compose exec wordpress wp --allow-root theme install https://github.com/understrap/understrap-child/archive/0.5.4.zip --activate
# 不要テーマの削除
docker-compose exec wordpress wp --allow-root theme uninstall twentynineteen twentyseventeen twentysixteen
# アップデート
docker-compose exec wordpress wp --allow-root core update
docker-compose exec wordpress wp --allow-root plugin update --all
docker-compose exec wordpress wp --allow-root theme update --all
docker-compose exec wordpress wp --allow-root core language update
#rootユーザーのファイルになってしまって困るのでまとめてオーナーとパーミッション変更
sudo chown -R $(whoami) docker_volumes
sudo chmod -R 777 docker_volumes