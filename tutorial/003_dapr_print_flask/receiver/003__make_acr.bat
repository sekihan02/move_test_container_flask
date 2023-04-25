@REM yamlの最後のserverに記載する
@REM ユーザー名とパスワードの表示
@REM az acr credential show --name TestMoveContainerResistry --query "{acrUsername:username,acrPassword:passwords[0].value}" -o tsv
@REM リソースグループの作成
@REM az group create --name myResourceGroup --location eastus

REM Azure Container Apps の作成
az containerapp create --resource-group myResourceGroup --name receiver --image $ACR_LOGIN_SERVER/receiver:latest --registry-username $ACR_NAME --registry-password $ACR_PASSWORD --dapr-components-path ./dapr-components --port 8888 --min-replicas 1
