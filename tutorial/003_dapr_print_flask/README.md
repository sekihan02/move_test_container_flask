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

## Redis のインストールと設定


---

最後の処理

セキュリティを考慮して、環境変数で Redis のホストとパスワードを指定します。

```
export REDIS_HOST=<your_redis_host>
export REDIS_PASSWORD=<your_redis_password>
```

- 作成したコンポーネント設定ファイルを dapr-components ディレクトリに配置します。このディレクトリを先程の az containerapp create コマンドで指定しています。

- すべてのデプロイが完了したら、コンテナにアクセスしてメッセージを送信して受信できることを確認します。

```
# Sender Container の URL を取得
SENDER_URL=$(az containerapp show --name sender --resource-group myResourceGroup --query 'properties.externalUrl' -o tsv)

# Receiver Container の URL を取得
RECEIVER_URL=$(az containerapp show --name receiver --resource-group myResourceGroup --query 'properties.externalUrl' -o tsv)

# Sender Container からメッセージを送信
curl $SENDER_URL/send_message

# Receiver Container からメッセージを確認
curl $RECEIVER_URL/dapr/subscribe
```

以上で、Azure Container Apps で 2 つのコンテナを作成し、Dapr を使用してメッセージを送受信できるようになりました。