@REM ローカルで試す場合、Dockerfileをaci_flask_movetestとしてbuild
@REM docker build -t aci_flask_movetest:0.1 .
@REM build後動作するかを確認 docker run --rm -p 5000:5000 aci_flask_movetest:0.1 アクセス先:http://localhost:5000

@REM Dockerイメージのビルドとプッシュを--registryで指定したコンテナレジストリに--imageで指定した名前とタグで登録
az acr build --registry TestMoveContainerResistry --image aci_flask_movetest:0.1 .
@REM 実行するとビルドに必要なファイルをACRに転送してACR上でイメージのビルドが開始されます
@REM 最後のログにRun ID: xxx was successfulと表示されていれば成功です
