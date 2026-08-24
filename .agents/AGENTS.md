# Global AGENTS.md

- 日本語で簡潔に回答する。
- 秘密情報や認証情報を出力しない。

## 開発フロー

- 変更は原則 `plan → implement → test → review` の順で進める。小さな変更も各工程を簡略化して適用する。
- 要件や事実に不明点がある場合は、必要に応じて `grilling` または `research` を先に使い、結果を `plan` に渡す。
- `plan` は対象、変更内容、検証方法、リスクを決める。`implement` は計画の範囲だけを編集する。
- `test` は検証コマンドを実行し、`review` はテスト結果と差分を読み取り専用で評価する。
- test の失敗は `implement → test`、review の指摘は `implement → test → review` に戻る。計画変更が必要なら `plan` に戻す。
- branch、commit、PR/MR はユーザーが明示的に依頼した場合だけ実行する。
