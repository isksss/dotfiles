# [dotfiles](https://github.com/isksss/dotfiles)

miseで管理するdotfilesです。

## 新しい環境への復元

1. miseを導入します。
2. このリポジトリのルートで `mise bootstrap dotfiles apply` を実行します。
3. opencodeの依存関係が必要な場合は `.config/opencode` で `npm install` を実行します。既存のlockfileに対応する標準コマンドでも再生成できます。

`node_modules` や `.omp` のruntimeデータ、キャッシュ、履歴、データベースはコピーしません。
