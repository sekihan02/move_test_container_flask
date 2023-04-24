FROM python:3.8

WORKDIR /app

ENV SLACK_BOT_TOKEN xoxb-***
ENV SLACK_APP_TOKEN xapp-***

COPY requirements.txt /app
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["python", "main.py"]
# CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]