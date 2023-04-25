# Azure Container Instances (ACI) を使用して 2 つのコンテナを作成し、Dapr を使用して 1 つ目のコンテナから 2 つ目のコンテナに文字列を送信する方法

## Dapr のインストールと設定
- [Dapr CLI](https://docs.dapr.io/getting-started/install-dapr-cli/) をインストール
恐らく`winget install Dapr.CLI`のコマンドでいけるはず

管理者権限でpowershellを開き
```
powershell -Command "iwr -useb https://raw.githubusercontent.com/dapr/cli/master/install/install.ps1 | iex"
```
駄目なら
```
Set-ExecutionPolicy RemoteSigned
```
実行権限を緩める

Dapr のランタイムをインストールします。
```
dapr init
```
DaprをDockerなしで初期化するなら
```
dapr init --slim
```
