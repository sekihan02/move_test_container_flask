@REM ローカルで試す場合、Dockerfileをaci_flask_movetestとしてbuild
@REM docker build -t receiver:latest .
@REM build後動作するかを確認 docker run --rm -p 8888:8888 receiver:latest

@REM Dockerイメージのビルドとプッシュを--registryで指定したコンテナレジストリに--imageで指定した名前とタグで登録
az acr build --registry TestMoveContainerResistry --image receiver:latest .
@REM 実行するとビルドに必要なファイルをACRに転送してACR上でイメージのビルドが開始されます
@REM 最後のログにRun ID: xxx was successfulと表示されていれば成功です
