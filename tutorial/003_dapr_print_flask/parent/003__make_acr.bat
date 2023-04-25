@REM yamlの最後のserverに記載する
@REM ユーザー名とパスワードの表示
@REM az acr credential show --name TestMoveContainerResistry --query "{acrUsername:username,acrPassword:passwords[0].value}" -o tsv
REM YAML ファイルを使用して、Azure Container Instances にデプロイ
@REM az container create --resource-group <YOUR_RESOURCE_GROUP> --file receiver.yaml
az container create --resource-group resorce-group --file receiver.yaml