# python3.9環境をrequirements.txt内のライブラリをインストールして作成
# ポート5000を開放する
FROM python:3.9

WORKDIR /app

RUN /usr/local/bin/python -m pip install --upgrade pip

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY app.py app.py

EXPOSE 5000

CMD [ "python", "app.py" ]
