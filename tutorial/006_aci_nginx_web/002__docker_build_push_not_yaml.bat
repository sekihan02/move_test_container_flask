@REM Dockerイメージのビルドとプッシュを--registryで指定したコンテナレジストリに--imageで指定した名前とタグで登録
az acr build --registry TestMoveContainerResistry --image aci-nginx:latest .
@REM 実行するとビルドに必要なファイルをACRに転送してACR上でイメージのビルドが開始されます
@REM 最後のログにRun ID: xxx was successfulと表示されていれば成功です

@REM ネットワークの種類 パブリック
@REM DNS 名ラベル aci-nginx-web
@REM TCP
@REM ポート80