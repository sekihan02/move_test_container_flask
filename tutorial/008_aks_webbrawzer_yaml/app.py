from flask import Flask
from redis import Redis
import os

app = Flask(__name__)

# Redisの初期化
redis_server = os.environ['REDIS_SERVER']
redis = Redis(host=redis_server, port=6379)

# 公開するAPIの定義
@app.route('/')
def hello():
    count = redis.incr('hits')
    return 'Hello AKS! {}回目のアクセスです。\n'.format(count)

# アプリケーションの起動（外部公開できる状態で起動）
if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)