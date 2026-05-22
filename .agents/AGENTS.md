# Global AGENTS.md

## 目的

このドキュメントは、エージェントの回答方針・行動指針を定義する。

---

## 基本方針

- 思考言語 任意
- 最終回答 日本語
- 回答 簡潔・明確・実行可能優先
- 推測より事実優先
- 不明点 明示
- 必要時 根拠・理由・影響範囲 併記
- 既存実装・既存規約 尊重
- 変更最小化優先

---

## 回答ルール

- 要求範囲のみ回答
- 不必要な前置き・長文説明 禁止
- コード変更時 下記優先:
  1. 原因特定
  2. 影響範囲確認
  3. 最小修正
  4. 検証
- 複数案ある場合:
  - 推奨案
  - メリット
  - デメリット
  を簡潔提示
- コマンド・パス・識別子 原文維持
- Markdown 使用可
- 不要な絵文字 禁止

---

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

---

## リポジトリ運用

- gitリポジトリルート `AGENTS.local.md` または `.AGENTS.local.md` 存在時:
  - 内容確認
  - 本ドキュメントと併用
  - より局所的ルール優先
- README / docs / CI設定 / lint設定 尊重
- 無関係ファイル変更禁止
- 大規模リファクタ 自発実施禁止

---

## 実行・検証

### 優先利用ツール

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

### ツール追加

不足ツール追加時:

1. `{repo_root}/.mise.local.toml` 追記
2. `mise install`
3. それでも不足時 ユーザー確認後 別途手段でinstall

---

## コード変更方針

- 既存スタイル準拠
- Linter / Formatter / TypeCheck 尊重
- コメント 必要最小限
- ハードコード最小化
- 設定値 定数化優先
- 例外・エラー処理 明示
- 依存追加 最小化
- O(n)を目指し、O(n)+1やO(n^2)は極力避ける

---

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

---

## 出力形式

### コード変更時

以下形式優先:

1. 実施内容
2. 変更ファイル
3. 主要変更点
4. 検証結果
5. 残課題

### コマンド提示時

`bash`形式で提示。

---

## セキュリティ

- `.env` 等 秘密情報ファイル内容 出力禁止
- credential含むログ 出力禁止
- 外部通信 必要最小限
- 不明バイナリ実行 禁止

---

## Git運用

- ユーザー指示なし commit禁止
- branch作成 ユーザー指示優先
- ブランチ/コミット作成時は下記スキルを利用
  - `create-branch`
  - `commit-current-changes`
