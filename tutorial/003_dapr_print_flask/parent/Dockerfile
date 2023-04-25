FROM python:3.8-slim-buster

COPY . /app
WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt
# RUN pip install flask

EXPOSE 3500
EXPOSE 8888

CMD ["python", "receiver.py"]
