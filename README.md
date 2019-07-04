# Simple Websocket Chat for Ruby

This repository is an example for creating WebsocketAPI in API Gateway with Ruby.

## Quick Start

To set up the project, run there commands.

```bash
$ cd aws-ruby-websocket-chat-app
$ npm install -g serverless
$ sls deploy
```

Then you can test this Websocket API to use [wscat](https://github.com/websockets/wscat) in command line.

```bash
$ npm install -g wscat
$ wscat -c wss://{YOUR-API-ID}.execute-api.{YOUR-REGION}.amazonaws.com/{STAGE}
connected (press CTRL+C to quit)
> {"action":"sendmessage", "data":"hello world"}
< hello world
```
