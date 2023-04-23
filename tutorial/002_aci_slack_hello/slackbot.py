"""
実行時: #generalにHelloworld!と返す
"""
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

# 適宜実行したいOAuth Tokens for Your WorkspaceのTokenを設定
slack_api_key = 'xoxb-5088505216708-5176987630064-i1TVdXZn2CqzIgMmmlXbRcdg'
slack_api_channel = '#general'
def SendToSlackMessage(message):
    client = WebClient(token=slack_api_key) 
    response=client.chat_postMessage(channel=slack_api_channel, text=message)

SendToSlackMessage("Helloworld!")