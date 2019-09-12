元のdocker image(wordpress 3.9くらいから存在する)
https://hub.docker.com/_/wordpress/
https://github.com/docker-library/wordpress

dockerのセットアップ
sudo apt-get install -y  apt-transport-https  ca-certificates  curl  software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
 $(lsb_release -cs) \
 stable"
sudo apt update
sudo apt install docker-ce
usermod -aG docker $USER
sudo usermod -aG docker $USER
sudo service docker start

docker-composeの簡単な使い方説明
start
docker-compose up -d
stop
docker-compose stop
ボリュームも含めて削除(このディレクトリ配下のファイルは消さない)
docker-compose down --volumes
bashの入り方
docker-compose exec wordpress bash

インストール直後にやっておくといいコマンドをinit_setup.shにまとめておいたので実行する
docker-compose up -d
chmod +x ./init_setup.sh
./init_setup.sh
adminerに以下のURLでアクセスできるようになる
https://localhost/adminer-4.7.3-en.php
WordPressが日本語用設定になる(タイムゾーン含め)
おすすめプラグイン追加&アクティベート
understrapテーマとunderstrap-childテーマの追加&アクティベート
不要テーマの削除

rootユーザーのファイルになってしまって困るのでまとめてオーナーとパーミッション変更
sudo chown -R $(whoami) docker_volumes
sudo chmod -R 777 docker_volumes

メールはPHP版mailtodiskを入れてあるのでdocker_volumes/web/mailoutputに出力される

wp-cliの使い方
docker-compose exec wordpress wp --allow-root help
例としてHOMEURLとSITEURLの書き換え
docker-compose exec wordpress wp --allow-root option update home 'https://新しいWordPressアドレス'
docker-compose exec wordpress wp --allow-root option update siteurl 'https://新しいWordPressアドレス/wp'

Logの表示
docker-compose logs
開発中は-fをつけておくとずっと表示できるので便利
docker-compose logs -f

全体的にやり直すには
docker-compose down --volumes
sudo rm -rf docker_volumes/*
sudo rmdir docker_volumes
docker rmi wordpress_wordpress

understrap-childと子テーマの開発について
参考サイト
https://www.ken-g.com/blog/archives/201803/understrap.html
header.phpやsidebar.phpなどのファイルを変更したい場合は親テーマディレクトリから子テーマディレクトリにファイルをコピーしてきて編集する
functions.phpの関数の上書きについて
add_action( 'after_setup_theme', '関数名', 11);
参考サイト：https://netamame.com/img-override
sassのコンパイルについて
cd wp-content/themes/understrap-child
npm install
gulp copy-assets
gulp watch
sassの記述は/sass/theme/_child_theme.scss
bootstrapの変数の記述は/sass/theme/_child_them_variables.scss
参考サイト：https://qiita.com/tonkotsuboy_com/items/1855734522bfe7ef7dad
参考サイト：https://homupedia.com/bootstrap4-how-to-customize-theme.html
understrap-childのバグ
https://github.com/understrap/understrap-child/pull/202
メニュー(ハンバーガーメニュー)に表示するには管理画面でメニューを作成してPrimary Menuにチェックを入れる
page navigatorはwp-pagenaviではなくunderstrapの関数を使う<?php understrap_pagination(); ?>

いつものwordpress関数を使うと親ルートの方に行ってしまう。
/*間違い 親テーマ時ならこれでいい*/
<?php echo get_template_directory_uri(); ?>
上記のものを子テーマのファイルに記しても親ルートを示してしまうので、子テーマに記す場合は下記のものを使う
/*正しい　子テーマ使用時のルートの示し方*/
<?php echo get_stylesheet_directory_uri() ?>

画像はテーマディレクトリに入れて以下のようにする
<img src="<?php echo get_stylesheet_directory_uri()">img/top.jpg>

wordpressの自動アップデート有効化
functions.php
// メジャーアップデート
add_filter( 'allow_major_auto_core_updates', '__return_true' );
// マイナーアップデート
add_filter( 'allow_minor_auto_core_updates', '__return_true' );
// テーマの自動更新
add_filter( 'auto_update_theme', '__return_true' );
// プラグインの自動更新
add_filter( 'auto_update_plugin', '__return_true' );

自己認証ファイル作成
openssl req -x509 -sha256 -nodes -days 3650 -newkey rsa:2048 -keyout server.key -out server.crt

ブロックの追加
https://wemo.tech/2163
