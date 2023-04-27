@REM ローカルで試す場合、Dockerfileをaci_flask_movetestとしてbuild
@REM docker build -t jupyterlab:0.5 .
@REM build後動作するかを確認 docker run --rm -p 1024:1024 jupyterlab:0.5

@REM # コンテナイメージのビルド
@REM docker build -t second-container .

@REM # Azure Container Registryにプッシュ
@REM docker tag second-container <registry-name>.azurecr.io/second-container:v1
@REM docker push <registry-name>.azurecr.io/second-container:v1


@REM Dockerイメージのビルドとプッシュを--registryで指定したコンテナレジストリに--imageで指定した名前とタグで登録
az acr build --registry TestMoveContainerResistry --image jupyterlab:0.5 .
@REM 実行するとビルドに必要なファイルをACRに転送してACR上でイメージのビルドが開始されます
@REM 最後のログにRun ID: xxx was successfulと表示されていれば成功です