FROM python:3.8-slim

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY sender.py sender.py

EXPOSE 80
EXPOSE 3500

CMD [ "python", "sender.py" ]