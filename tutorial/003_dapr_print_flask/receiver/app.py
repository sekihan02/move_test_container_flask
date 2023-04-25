from flask import Flask, request
from flask_dapr import DaprClient

app = Flask(__name__)
dapr = DaprClient(app)

@app.route('/dapr/subscribe', methods=['GET'])
def subscribe():
    return [{"topic": "messages", "route": "/receive_message"}]

@app.route('/receive_message', methods=['POST'])
def receive_message():
    message = request.json['data']
    return f"Received message: {message}"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8888)
