import requests

def send_message(message: str):
    dapr_port = 3500
    dapr_url = f'http://localhost:{dapr_port}/v1.0/invoke/receiver/method/receive-message'
    headers = {'Content-Type': 'application/json'}
    response = requests.post(dapr_url, json={'message': message}, headers=headers)
    return response.json()

if __name__ == '__main__':
    message = 'Hello, from Sender!'
    response = send_message(message)
    print(f'Response from receiver: {response}')
