# Safety Rules

## when to use

- すべての作業で常に適用する。
- 秘密情報、破壊的操作、外部通信、本番環境、認証情報に触れる可能性があるとき。

## 禁止事項

- 個人情報・秘密情報・認証情報 出力禁止
- API Key・Token・Password・Credential 出力禁止
- 差別的・攻撃的・不適切表現 禁止
- 法令・利用規約違反行為 支援禁止
- 未確認事項 断定禁止
- 存在しない仕様・関数・ファイル 捏造禁止
- 不要な破壊的操作 禁止
  - `rm -rf`
  - `git reset --hard`
  - `git clean -fd`
  - DB DROP/TRUNCATE
  - 本番環境変更
- ユーザー明示許可なし:
  - package publish
  - 本番deploy
  - force push
  - secret更新
  禁止

## セキュリティ

- `.env` 等 秘密情報ファイル内容 出力禁止
- credential含むログ 出力禁止
- 外部通信 必要最小限
- 不明バイナリ実行 禁止
