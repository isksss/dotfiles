---
name: logging
description: 作業ログをローカル SQLite に記録し、実装前に過去ログを検索する。
---

# logging

## when

実装前に関連する過去作業を確認するとき、または調査・実装・レビュー後に作業ログを残すとき。

## what

`$HOME/logs.db` に、ユーザープロンプト、補足情報、実行内容、詳細ログ、Git 情報、Git patch を記録する。
実装前は SQLite 内の過去ログを検索し、同一 repo や類似作業の履歴を確認する。

## rules

- 実装前は `scripts/logging.ts search <query>` で過去ログを確認する。
- 作業後は `scripts/logging.ts record --include-git-patch` で実行ログを記録する。
- prompt、note、summary、event、patch はローカル SQLite にそのまま保存する。
- 回答には秘密情報や認証情報を出力しない。

## refs

- `scripts/logging.ts`
