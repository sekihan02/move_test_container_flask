@REM yamlの最後のserverに記載する
@REM ユーザー名とパスワードの表示
@REM az acr credential show --name TestMoveContainerResistry --query "{acrUsername:username,acrPassword:passwords[0].value}" -o tsv
@REM YAML ファイルを使用して、Azure Container Instances にデプロイ
@REM az container create --resource-group <YOUR_RESOURCE_GROUP> --file sender.yaml
@REM az container create --resource-group resorce-group --file sender.yaml

az containerapp create --resource-group myResourceGroup --name receiver --image $ACR_LOGIN_SERVER/receiver:latest --registry-username $ACR_NAME --registry-password $ACR_PASSWORD --dapr-components-path ./dapr-components --port 8888 --min-replicas 1