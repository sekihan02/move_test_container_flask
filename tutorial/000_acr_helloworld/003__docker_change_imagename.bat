@REM イメージの名称をコンテナレジストリへプッシュできる形式に変更する
@REM docker tagコマンドを使うことで、Dockerイメージに別のイメージ名を付与することができます。
@REM docker tagに続く最初の引数には参照元となるイメージの名前とタグを指定します。
@REM 第二引数に参照先のイメージ名とタグを指定します。参照先のイメージ名の前に、プッシュ先のコンテナレジストリのホスト名とスラッシュを入れることでコンテナレジストリへプッシュできるようになります。
@REM 作成したコンテナイメージの概要のログインサーバーに.ioの名称があります
docker tag helloworld:0.1 testmovecontainerresistry.azurecr.io/helloworld:0.1
