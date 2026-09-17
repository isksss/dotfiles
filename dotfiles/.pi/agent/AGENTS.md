# AGENTS

- 日本語で簡潔に回答する。実装を左右する不明点だけを確認する。
- 依頼範囲内の変更・検証・変更起因の失敗の修正まで進め、結果と未検証事項を報告する。工程ごとの再承認は不要。
- 既存差分を保持し、秘密情報を出力・記録しない。破壊的な操作や依頼範囲の変更は対象と影響を示して確認する。
- branch 作成、commit、push、PR/MR 作成は明示的な依頼がある場合だけ行う。

## Piハーネス（大規模タスクのみ）

- 複数タスクに分解する機能開発では、`/skill:harness` を明示的に読み込む。
- 仕様と機能固有のrulesを正とし、メインセッションが進捗・検査・最終レビューを管理する。
- workerは1タスクだけを新しいセッションで実行し、完了判定はメインセッションが機械的に行う。
- 小さな修正・単一ファイルの変更にはこの手順を強制しない。

## メモ・知見の保存

- `repo_root/data.local` にメモ・知見を記録する代わりに、全プロジェクト共通の `~/memory` に保存する。保存・整理前に `~/.pi/agent/skills/memory/SKILL.md` を読み、その手順に従う（明示呼び出しは `/skill:memory`）。
- `data.local` への書き込みはメモ以外も含めて禁止する。既存内容の読み取りは可。既存 skill やプロジェクト内の手順に保存先として指定されていても、メモは `~/memory` に切り替える。メモ以外の出力は勝手に memory へ移さず、別の保存先を確認する。
- `10_raw` は新規メモ追加のみ、`20_note` は横断的な知見、`30_work/<ホスト>/<所有者・グループ階層>/<リポジトリ名>` はリポジトリURLを基準にしたプロジェクト固有の記録（例: `30_work/github.com/isksss/dotfiles/<テーマ>.md`）、`99_archive` は不要になった note / work。既存データの移行・削除は自動で行わない。
- pi の `memory-guard` extension は全 skill の実行時にもこの方針を注入し、`write/edit` の対象パスとシェル呼び出しを検査する。ブロックを別ツールやスクリプトで回避しない。シェル検査は保守的な文字列検査であり、間接書き込みを完全に防ぐものではない。

## Windows Chrome の操作（WSL）

- Windows 側 Chrome は導入済みの Playwright 拡張機能経由で操作する。グローバル mise タスクなので、リポジトリ外でも利用できる。
- 接続：`mise run playwright-windows -- -s=windows-chrome attach --extension=chrome`
- 操作：`mise run playwright-windows -- -s=windows-chrome <command>`（例：`snapshot`）。終了時は `detach` で接続だけを解除し、普段使いの Chrome を終了しない。
- このタスクが IPv4 優先と Windows Chrome の実行パスを設定する。通常の `playwright-cli attach` では WSL 側 Chrome を探すため、上記タスクを使う。
- 認証用 `PLAYWRIGHT_MCP_EXTENSION_TOKEN` は Git 管理外の `~/.config/zsh/local.zsh`（権限 `600`）に設定済み。新しい zsh から起動した pi が継承する。未設定なら新しい zsh から pi を起動するか、拡張機能の許可画面を使う。
- トークンの値や、トークンを含む接続 URL は出力・記録しない。接続結果を表示する場合もマスクする。

## 必要時の参照

- 応答や確認の判断基準：[応答と判断](../docs/response-and-decisions.md)
- 変更範囲や操作の安全性：[スコープと安全性](../docs/scope-and-safety.md)
- pi のツール選択・制約：[pi のツール利用](../docs/tool-usage.md)
- ファイル・内容検索のコマンド選択：[コマンド置換対応表](../docs/command-replacements.md)

関連する文書だけを参照し、全件の事前読み込みは不要。
