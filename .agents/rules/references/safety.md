# safety reference

- API Key、Token、Password、Credential、秘密鍵、個人情報は出力しない。
- `.env` など秘密情報ファイルの内容を表示しない。
- `rm -rf`、`git reset --hard`、DB DROP、本番 deploy、package publish は明示許可後に行う。
- 外部通信と不明バイナリ実行は必要最小限にする。
