@REM ローカルで試す場合、Dockerfileをaci_flask_movetestとしてbuild
docker build -t slack_bot:latest .
@REM build後動作するかを確認 Slackの設定で、Slash Commandsを作成して、リクエストをこのアプリケーションのURLに転送するように設定してください。 http://<your_server_ip>:5000/weather
docker run -p 8000:8000 --rm slack_bot:latest

@REM Dockerイメージのビルドとプッシュを--registryで指定したコンテナレジストリに--imageで指定した名前とタグで登録
@REM az acr build --registry TestMoveContainerResistry --image slack_bot:latest .
@REM 実行するとビルドに必要なファイルをACRに転送してACR上でイメージのビルドが開始されます
@REM 最後のログにRun ID: xxx was successfulと表示されていれば成功です
