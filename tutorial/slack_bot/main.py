# https://qiita.com/ina111/items/0591ab8714139e67b19c
# https://slack.dev/bolt-python/ja-jp/tutorial/getting-started#create-an-app
import os
from slack_bolt import App
from slack_bolt.adapter.socket_mode import SocketModeHandler

# ボットトークンとソケットモードハンドラーを使ってアプリを初期化します
app = App(token=os.environ.get("SLACK_BOT_TOKEN"))

# 'hello' を含むメッセージをリッスンします
# 指定可能なリスナーのメソッド引数の一覧は以下のモジュールドキュメントを参考にしてください：
# https://slack.dev/bolt-python/api-docs/slack_bolt/kwargs_injection/args.html
# @app.message("hello")
# def message_hello(message, say):
# メンションされたら動作
@app.event("message")
def message_hello(event, say):
    # イベントがトリガーされたチャンネルへ say() でメッセージを送信します
    input_message = event['text']
    # input_message = message['text']
    input_message = input_message.replace("<@hogehoge>", "") # ChatbotのアカウントIDの＠を削除, hogehogeをアプリのIDに変換
    say(f"Hey there {input_message}")

# アプリを起動します
if __name__ == "__main__":
    handler = SocketModeHandler(app, os.environ["SLACK_APP_TOKEN"])
    handler.start()