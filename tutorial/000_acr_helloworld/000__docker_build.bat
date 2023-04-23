@REM Dockerfileをhelloworldとしてbuild
docker build -t helloworld:0.1 .
@REM build後動作するかを確認 docker run --rm helloworld:0.1
