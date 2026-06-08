# commit workflow

- `git status --short --branch`、diff、未追跡ファイルを確認する。
- 秘密情報、個人情報、生成物、無関係差分を除外する。
- 必要なら commit 範囲を分割する。
- メッセージは `[prefix] 日本語の要約` と本文にする。
- 既定 prefix は add、fix、update、remove、refactor、docs、test、chore、perf、ci。
- `git add .` は避け、対象パスだけ stage する。
