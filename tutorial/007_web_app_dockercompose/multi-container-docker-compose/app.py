"""
Redisのネットワークをホスト名'redis'、ポート6379で初期化
redis.incr('hits')でRedisのINCRコマンドを実行(hitshをインクリメントする)
"""
from flask import Flask
from redis import Redis

app = Flask(__name__)
redis = Redis(host='redis', port=6379)

@app.route('/')
def hello():
    # Redisの更新
    count = redis.incr('hits')
    return f'Hello World! {count}回目のアクセスです。\n'

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)