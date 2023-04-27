Azure Kubernetes Service (AKS) と Azure Container Registry (ACR) を使用して、Dapr を使って 2 つの Docker コンテナ間で文字列を送信し、受信側のコンテナでブラウザに文字列を表示する方法について説明します。

1. Azure Container Registry (ACR) の作成:
Azure Portal で新しい ACR を作成するか、既存の ACR を使用します。以下のドキュメントを参考にしてください。
https://docs.microsoft.com/ja-jp/azure/container-registry/container-registry-get-started-portal

2. Docker イメージをビルドして ACR にプッシュ:
2 つの Docker イメージを作成し、それらをビルドして ACR にプッシュします。

Dockerfile-sender:
```Dockerfile
FROM python:3.9

# Install Dapr SDK
RUN pip install dapr

# Set working directory
WORKDIR /app

# Copy the sender app
COPY ./sender.py .

# Expose Dapr port
EXPOSE 3500

# Start the sender app
CMD ["python", "sender.py"]
```

Dockerfile-receiver:
```Dockerfile
FROM python:3.9

# Install Flask and Dapr SDK
RUN pip install Flask dapr

# Set working directory
WORKDIR /app

# Copy the receiver app
COPY ./receiver.py .

# Expose Flask and Dapr ports
EXPOSE 5000 3500

# Start the receiver app
CMD ["python", "receiver.py"]
```

ローカルでイメージをビルドし、ACR にプッシュします。
```bash
# Sender
docker build -t <acr_name>.azurecr.io/sender:latest -f Dockerfile-sender .
docker push <acr_name>.azurecr.io/sender:latest

# Receiver
docker build -t <acr_name>.azurecr.io/receiver:latest -f Dockerfile-receiver .
docker push <acr_name>.azurecr.io/receiver:latest
```

3. Dapr を使ったアプリケーションの作成:
Python で sender.py と receiver.py を作成します。

sender.py:
```python
import time
from dapr.clients import DaprClient

client = DaprClient()

while True:
    response = client.publish_event(
        pubsub_name='pubsub',
        topic='message',
        data='Hello from Sender!'
    )
    print('Message sent:', response.status_code)
    time.sleep(5)
```

receiver.py:
```python
from flask import Flask
from dapr.ext.grpc import App

app = Flask(__name__)
dapr_app = App(app)

received_messages = []

@dapr_app.subscribe(pubsub_name='pubsub', topic='message')
def my_endpoint(request):
    global received_messages
    received_messages.append(request.data)
    print('Received message:', request.data)
    return '', 200

@app.route('/')
def index():
    return '<br>'.join(received_messages)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

4. AKS クラスターにデプロイ:

まず、AKS クラスターが既に作成されていることを確認してください。もしまだ作成されていなければ、以下のドキュメントを参照して作成してください。
https://docs.microsoft.com/ja-jp/azure/aks/kubernetes-walkthrough-portal

次に、Dapr を AKS クラスターにインストールします。`dapr` CLI を使って、以下のコマンドを実行します。

```bash
dapr init --kubernetes
```

これで、AKS クラスター上に Dapr がインストールされます。

続いて、Kubernetes デプロイメントとサービスを作成するための YAML ファイルを作成します。以下の YAML ファイルを作成し、`deployment.yaml` として保存します。

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: acr-auth
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: <base64-encoded-docker-auth-config>

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sender
spec:
  replicas: 1
  selector:
    matchLabels:
      app: sender
  template:
    metadata:
      labels:
        app: sender
      annotations:
        dapr.io/enabled: "true"
        dapr.io/app-id: "sender"
        dapr.io/app-port: "3500"
    spec:
      containers:
      - name: sender
        image: <acr_name>.azurecr.io/sender:latest
        ports:
        - containerPort: 3500
      imagePullSecrets:
      - name: acr-auth

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: receiver
spec:
  replicas: 1
  selector:
    matchLabels:
      app: receiver
  template:
    metadata:
      labels:
        app: receiver
      annotations:
        dapr.io/enabled: "true"
        dapr.io/app-id: "receiver"
        dapr.io/app-port: "5000"
    spec:
      containers:
      - name: receiver
        image: <acr_name>.azurecr.io/receiver:latest
        ports:
        - containerPort: 5000
      imagePullSecrets:
      - name: acr-auth

---
apiVersion: v1
kind: Service
metadata:
  name: receiver-service
spec:
  selector:
    app: receiver
  ports:
    - protocol: TCP
      port: 80
      targetPort: 5000
  type: LoadBalancer
```

`<base64-encoded-docker-auth-config>` と `<acr_name>` の部分を適切な値に置き換えてください。

YAML ファイルを適用して、デプロイメントとサービスを作成します。

```bash
kubectl apply -f deployment.yaml
```

5. AKS クラスターにデプロイ:

`receiver-service` の External IP が割り当てられたら、ブラウザでその IP アドレスにアクセスします。これにより、`receiver` コンテナで受信した文字列が表示されます。

例: http://<External_IP>

ここで、`sender` コンテナから送信された文字列が、Dapr を通じて `receiver` コンテナに送信され、`receiver` コンテナでブラウザに表示されることが確認できます。送信される文字列が追加されるたびに、表示される文字列が更新されます。

これで、Azure Kubernetes Service (AKS) を使って 2 つの Docker コンテナを Azure Container Registry (ACR) に作成し、Dapr を使用して文字列の送信を行い、送信しなかった別の Docker コンテナの環境で文字列を受信してブラウザで表示する方法を実装できました。