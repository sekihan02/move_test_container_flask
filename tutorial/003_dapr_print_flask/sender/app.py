from flask import Flask
from flask_dapr import DaprClient
import requests

app = Flask(__name__)
dapr = DaprClient(app)

@app.route('/send_message')
def send_message():
    message = "Hello from Sender Container"
    dapr.publish_event(pubsub_name='pubsub', topic='messages', data=message)
    return "Message sent"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
