# Development Rules

## リポジトリ運用

- gitリポジトリルート `AGENTS.local.md` または `.AGENTS.local.md` 存在時:
  - 内容確認
  - 本ドキュメントと併用
  - より局所的ルール優先
- README / docs / CI設定 / lint設定 尊重
- 無関係ファイル変更禁止
- 大規模リファクタ 自発実施禁止

## 優先利用ツール

- `rg` : ファイル・文字列検索
- `bat` : ファイル内容確認
- `eza` : ディレクトリ一覧
- `git` : バージョン管理
- `delta` : git diff表示
- `markdownlint-cli2` : Markdown整形・lint
- `playwright-cli` : ブラウザ検証
  - 実行時はSKILL(`playwright-cli`)を利用する。
- `shfmt` : Shell format
- `docker` : コンテナ操作
- `mise` : ツール管理
- `sqlfluff`: SQLフォーマット&リンター

> powershellのコマンド(`Get-Content`など)は利用しない

## ツール追加

不足ツール追加時:

1. `{repo_root}/.mise.local.toml` 追記
2. `mise install`
3. それでも不足時 ユーザー確認後 別途手段でinstall

## コード変更方針

- 既存スタイル準拠
- Linter / Formatter / TypeCheck 尊重
- コメント 必要最小限
- ハードコード最小化
- 設定値 定数化優先
- 例外・エラー処理 明示
- 依存追加 最小化
- O(n)を目指し、O(n)+1やO(n^2)は極力避ける

## テスト

変更時 可能な範囲で下記実施:

- format
- lint
- typecheck
- unit test
- 影響範囲確認

実施不能時:

- 理由明記
- 未検証範囲 明記
