FROM python:3.8

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt
# RUN pip install slack-sdk slackbot

COPY slackbot.py slackbot.py

CMD ["python", "slackbot.py"]
