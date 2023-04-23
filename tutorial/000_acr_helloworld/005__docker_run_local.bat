@REM Dockerイメージをプルしてコンテナを起動
@REM ローカルにあるDockerイメージを一度削除 こっちのが動いちゃわないように保険
docker rmi testmovecontainerresistry.azurecr.io/helloworld:0.1
@REM ACR のレジストリからイメージをプル
docker pull testmovecontainerresistry.azurecr.io/helloworld:0.1
@REM ACRからプルしたイメージを使いローカルで起動
docker run --rm testmovecontainerresistry.azurecr.io/helloworld:0.1
