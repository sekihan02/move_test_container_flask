# ベースイメージとしてpythonを使用する
FROM python:3.4-alpine

# アプリケーションの配置と依存関係のインストール
ADD . /code
WORKDIR /code
RUN pip install -r requirements.txt

# 公開するポートの指定
EXPOSE 5000

# 起動時のコマンドの指定
CMD ["python", "app.py"]