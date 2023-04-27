Azure Kubernetes Service(AKS)はKubernetesをAuzre上で実行できます。

Kubernetesは複数のコンテナ実行管理ツールです
Dockerは単一マシンでのコンテナの運用であるのに対し、Kubernetesは複数のマシンにまたがってコンテナの実行を管理するための機能を持っています。DockerではDockerfileを使った方法などでコンテナを作成、登録ができますが、Kubernetesはあコンテナの実行のみです

イメージをACRにプッシュすることができたら、AKSを作成します。
Azure Kubernetes Service (AKS)で検索し、設定は、クラスターのプリセット構成をテストなら`Dev/Test`, 実行なら`Standard`かと
統合タブでKubernetesクラスターを他のAzureリソースと連携させることができます。コンテナーレジストリから、使用するコンテナイメージをプッシュしたレジストリを選択し、確認および作成を選択します

Kubernetesクラスターの作成が完了したら、マニュフェストファイルを使ってアプリケーションをAKS上にデプロイしていきます。もしエラーになった場合、ノード数の範囲が1なことが理由な可能性がありますので範囲を2or5ほどにふやして見てください
作成したKubernetesクラスターのリソースの概要から作成→YAMLで作成で以下のYAMLを入力

```yaml
# Redis用のデプロイ定義・・・①
apiVersion: apps/v1
kind: Deployment # マニュフェストの種類を指定する・・・①-1
metadata:
  name: zerokara-aks-db
spec:
  replicas: 1 # Podのレプリカ数を指定する・・・①-2
  selector:
    matchLabels:
      app: zerokara-aks-db # 他のリソースが参照するためのラベルを定義する・・・①-3
  template:
    metadata:
      labels:
        app: zerokara-aks-db
    spec:
      nodeSelector:
        "kubernetes.io/os": linux
      containers: # Podで実行するコンテナの情報を記述する・・・①-4
        - name: zerokara-aks-db
          image: mcr.microsoft.com/oss/bitnami/redis:6.0.8
          env:
          - name: ALLOW_EMPTY_PASSWORD
            value: "yes"
          ports:
          - containerPort: 6379
            name: redis
---
# Redis用のサービス定義・・・②
apiVersion: v1
kind: Service # サービスとしてマニュフェストを定義する・・・②-1
metadata:
  name: zerokara-aks-db
spec:
  ports:
  - port: 6379 # 外部に公開するポート番号の指定・・・②-2
  selector:
    app: zerokara-aks-db # サービスに紐付けるPodを参照する・・・②-3
---
# Webアプリケーション用のデプロイ定義・・・③
apiVersion: apps/v1
kind: Deployment
metadata:
  name: zerokara-aks-web
spec:
  replicas: 1
  selector:
    matchLabels:
      app: zerokara-aks-web
  template:
    metadata:
      labels:
        app: zerokara-aks-web
    spec:
      nodeSelector:
        "kubernetes.io/os": linux
      containers:
        - name: zerokara-aks-web
          image: zerokara.azurecr.io/zerokara-aks-webapp:latest # 自身で作成したコンテナイメージを参照・・・③-1
          ports:
            - containerPort: 5000
          env:
            - name: REDIS_SERVER # DBとして使用するRedisのサービス名を環境変数として設定・・・③-2
              value: zerokara-aks-db
---
# Webアプリケーション用のサービス定義・・・④
apiVersion: v1
kind: Service
metadata:
  name: zerokara-aks-web
spec:
  type: LoadBalancer # Kubernetes外からアクセスできるようにLoadBalancerタイプのサービスとする・・・④−1
  ports:
  - port: 80 # 外部に公開するポート番号の指定・・・④-2
    targetPort: 5000 # アクセス先のPodが公開しているポート番号の指定・・・④-3
  selector:
    app: zerokara-aks-web
```

マニュフェストファイルが正しく追加できると４つのリソース（２つのDeploymentと２つのService）が作成されます。そのためマニュフェストファイルを確認すると、ハイフン（---）で区切られた4つのリソース定義から構成されていることが分かります。ここではマニュフェストファイルの項目について、ポイントとなる部分に絞って説明します。

・データベース（Redis）用のデプロイ定義（①のブロック）
　データベースとして使用するRedisのデプロイ方法について定義したものが①のブロックです。「kind」を「Deployment」とすることで、Podのデプロイ方法についての定義が記述できます（①-1）。「spec」のセクション内に詳細な情報を記述していきます。「spec.replicas」ではPodのレプリカ数を指定できます（①-2）。「spec.selector」ではこのデプロイ定義によって作成されたリソースを他のリソースが参照する際に使用するラベルを設定することができます（①-3）。これは後述するサービスの定義などで使用します。「spec.template」のセクション内ではPodとして実行するコンテナアプリケーションについて指定していきます。「spec.template.spec.containers」のセクション内で実際に使用するRedisのコンテナイメージの参照元となるコンテナレジストリのタグ名やポート番号などについて記述します（①-4）。

・データベース（Redis）用のサービス定義（②のブロック）
　①のブロックでRedisのデプロイ方法について記述したので、そのRedisを他のリソースからアクセスできるようにするためにサービスの定義をセットで行います。サービスの場合は、「kind」を「Service」とします（②-1）。「spec.ports」でこのサービスが公開するポート番号を指定します（②-2）。このポート番号は、①-4で設定したRedisコンテナのポート番号と合わせます。「spec.selector」でこのサービスを経由してアクセスするリソースを決定します（②-3）。ここには先程①-3で設定したラベル名を指定します。

・Webアプリケーション用の定義（③と④のブロック）
　Webアプリケーション用の定義もデータベース用の定義と同様に、「Deployment」と「Service」のセットでマニュフェストを作成します。デプロイ定義では、自身が作成したFlaskのWebアプリケーションをデプロイしたいため、コンテナイメージをプッシュしたACRのタグ名を指定します（③-1）。またコンテナに対して環境変数を設定するようにしています（③-2）。これにはWebアプリケーションのコンテナがデータベースとして使うRedisコンテナの接続先ホスト名を設定します。Kubernetesの場合、サービス名をホスト名とするため②で定義したサービスの名称を環境変数の値として使用します。
　Webアプリケーション用のサービスの定義では、WebブラウザなどKubernetes外からのアクセスを受け付けるために「spec.type」で「LoadBalancer」と指定します（④−1）。LoadBalancer型でサービスを作成すると、AKSがAzure Load Balancerを使ったロードバランサー機能を提供するように内部的に構成されます。これによってサービスにはパブリックIPが割り当てられるようになります。「spec.ports」では2種類のポート番号を定義しています。「spec.ports.port」の方はこのサービスが公開するポート番号の指定（④-2）で、「spec.ports.targetPort」の方はサービスからPodにアクセスする際のPod側のポート番号を指定します（④-3）。この設定により、Webブラウザからアクセスする際はポート80番でアクセスできるためURLでポート番号を明示する必要なくWebアプリケーションにアクセスできるようになります。

デプロイしたアプリケーションの動作確認は左側のメニューから「サービスとイングレス」、サービスの一覧の中から「zerokara-aks-web」という名前のサービスを探し、「外部IP」の列に表示されているIPアドレスを選択すること