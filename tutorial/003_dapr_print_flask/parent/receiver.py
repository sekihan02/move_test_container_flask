from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/receive-message', methods=['POST'])
def receive_message():
    message = request.json['message']
    print(f'Received message: {message}')
    return jsonify({'result': f'Message received: {message}'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8888)