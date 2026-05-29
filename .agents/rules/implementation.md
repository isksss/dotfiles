# Implementation Rules

## when to use

- コード、設定、ドキュメント、テンプレートを変更するとき。
- 調査結果や計画をもとに実装を進めるとき。

## 実装方針

- 既存実装、既存規約、周辺コードの設計を優先する。
- 変更は要求範囲に限定し、無関係なリファクタや整形を避ける。
- 新しい依存、抽象化、設定値は必要性が明確な場合だけ追加する。
- エラー処理、境界条件、後方互換性を確認する。
- 実装担当は、調査担当の記録と計画を確認してから変更する。

## 言語別の目線

- Shell: `set -e` など既存方針、quote、終了コード、POSIX/zsh/bash 差分を確認する。
- TypeScript/JavaScript: 型、null/undefined、非同期処理、既存 formatter/linter を確認する。
- Vue/Nuxt: props、state、CSR/SSR 前提、既存 component 分割を確認する。
- Go: error handling、context、race、既存 package boundary を確認する。
- Rust: ownership、Result、panic 回避、既存 module boundary を確認する。
- Python: 型ヒント、例外、依存追加、実行環境を確認する。
- Markdown/Docs: 正本、リンク先、利用者が実行できる手順を確認する。
