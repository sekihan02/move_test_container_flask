@REM 「steps」ブロック内にACRタスクで実行したい手順を順に記載
@REM 「build」にイメージのビルド
@REM 「$」から始まる文字はRun変数でACRで既定の変数です
@REM $Registryはレジストリ名、$IDはACRタスクの実行ごとに割り振られるユニークな文字列
@REM 「cmd」ではDockerイメージからコンテナを起動することができるのでコンテナの起動テストに使えます
@REM detach: trueはバックグラウンド実行
@REM portsはプロパティで公開するポート
@REM コンテナの起動に成功すると、２つ目のcmdが実行されます
@REM ２つ目は１つ目のcmdで起動したコンテナを「docker stop」で停止し、ACR上のリソースをクリーンアップするステップです。
@REM 最後に「push」
az acr run -r testmovecontainerresistrytestmovecontainerresistry.azurecr.io -f task.yaml .
@REM 実行するとビルドに必要なファイルをACRに転送してACR上でイメージのビルドが開始されます
@REM 最後のログにRun ID: xxx was successfulと表示されていれば成功です