# [dotfiles](https://github.com/isksss/dotfiles)

`mise` で管理する個人用 dotfiles です。Arch Linux を主対象とし、Ubuntu と macOS は best-effort で扱います。Windows と PowerShell は対象外です。

## セットアップ

`git` と `curl` を用意して、bootstrap を実行します。リポジトリの clone、`mise` の導入、dotfiles の symlink 作成、ツールの初期化を行います。

```sh
curl -fsSL https://raw.githubusercontent.com/isksss/dotfiles/main/bootstrap.sh | sh
```

## 基本操作

```sh
cd ~/dotfiles
mise dotfiles status
mise dotfiles apply --dry-run --verbose
mise dotfiles apply
mise run check
```

## pi + ChatGPT Pro / llama.cpp

設定を反映します。既定プロバイダは `openai-codex`、モデルは `gpt-6-astra`、推論レベルは `low` です。
既存の `~/.pi/agent/settings.json` がある場合は、内容を確認してから `--force` を付けてください。

```sh
mise dotfiles apply --force
```

初回のみ、設定に含まれるグローバルパッケージをインストールします。

```sh
pi install npm:pi-mono-ask-user-question
pi install git:github.com/DietrichGebert/ponytail
```

`pi` を起動し、`/login` で **ChatGPT Plus/Pro (Codex)** を選択して、
ブラウザで ChatGPT Pro 契約のあるアカウントにログインします。OpenAI APIキーは不要です。

```sh
pi
```

pi内では `/model` で `gpt-5.6-luna`、`/thinking` で `xhigh` を確認できます。

WSL の画像貼り付けは `Ctrl+V`、`Alt+V`、`F12` に割り当てています。設定反映後、piを再起動するか `/reload` を実行してください。

`auto-session-name.ts` 拡張機能が、新規セッションの最初のユーザー発言を
`openai-codex/gpt-5.6-luna` で要約し、日本語30文字以内のセッション名を付けます。
通常の会話モデルは変更しません。
要約用にモデルを1回追加呼び出しするため、通常の応答開始前に最大20秒の待ち時間と
追加の利用量が発生します（要約対象は先頭8000文字、画像は対象外）。
既存の会話・設定済みの名前は変更せず、失敗しても会話は続行します。
手動変更は `/name 新しい名前`、拡張機能の読み込みは `/reload` で行えます。
単体テストは `node --test tests/auto-session-name.test.mjs` で実行します。

複数タスクに分ける機能開発では、`/skill:harness` を明示的に読み込みます。
`subagent` ツールが `planner`、`worker`、4観点のレビュアーをセッション分離して起動します。
進捗ファイルは `plans/pi-harness/` に置かれ、既存の `plans/**` ルールでGit管理外です。
設定反映後は pi を再起動するか `/reload` を実行してください。

ローカルモデルを使う場合だけ、モデルを読み込むサーバーを起動します。

```sh
mise run llama-pi-server
```

別のターミナルで `pi` を起動します。`~/.cache/llmfit/models` にある
`Qwen2.5-Coder-7B-Instruct-Q8_0.gguf` をローカルモデルとして利用できます。

llama.cppを使う場合は、初回に pi で `/login llama.cpp` を実行し、サーバー URL に
`http://127.0.0.1:8080` を入力してください。API key は空のまま Enter で進み、
`/llama` で Qwen モデルをロードした後、`/model` で選択します。サーバーは `127.0.0.1:8080` の
ローカルからのみ接続できます。すでに同じポートで `llama-server -m` を起動して
いる場合は、先にそのプロセスを終了してください。終了する場合は
`llama-pi-server` を実行しているターミナルで `Ctrl-C` を押します。

OpenCode から使う場合は、同じサーバーを起動した状態でモデルを指定して起動します。

```sh
opencode -m llama.cpp/Qwen2.5-Coder-7B-Instruct-Q8_0
```

## WSL から Windows Chrome を操作する

Windows Chrome に Playwright 拡張機能を導入した環境では、pi から次のタスクを実行します。
初回は `mise install npm:@playwright/cli` で CLI を用意してください。

```sh
mise run playwright-windows -- -s=windows-chrome attach --extension=chrome
mise run playwright-windows -- -s=windows-chrome snapshot
mise run playwright-windows -- -s=windows-chrome detach
```

トークン未設定時は Chrome の許可画面で対象タブを選びます。
自動認証には `PLAYWRIGHT_MCP_EXTENSION_TOKEN` を実行環境から渡してください。
zsh では Git 管理外の `~/.config/zsh/local.zsh` に設定できます。
秘密情報を含むため、このファイルの権限は `600` にしてください。
設定後は新しい zsh から pi を起動します。
`detach` は Chrome を終了せず、接続だけを解除します。

このタスクだけ IPv4 を優先し、`C:\Program Files\Google\Chrome\Application\chrome.exe`
を使います。WSL・Chrome の自動起動やファイアウォールの変更は行いません。
CLI は接続検証済みの `0.1.18` に固定しています。

## pi用メモskill

`mise dotfiles apply` で `~/.pi/agent/skills/memory` への配置を反映してから、piを起動します。
このskillはpi専用の配置とし、`~/.agents/skills/` には追加しません。

```text
/skill:memory この会話を raw に保存して。次回は異常系テストから再開する
/skill:memory 異常系テストのメモを検索して
/skill:memory このプロジェクトの作業メモを保存して
```

メモ・知見は `~/memory` に保存します。雑記は `10_raw`、横断的な知見は `20_note`、
プロジェクト固有の記録は `30_work`、不要になった note / work は `99_archive` で管理します。
秘密情報は除外し、raw は新規追加のみ。検索ではメモの変更や記載された作業の自動実行はしません。
`memo-read` / `memo-write` は廃止し、`memory` に統一しました。既存の `~/memo` は自動移行しません。

## 設定

### Neovim

Rust・Go・TypeScript・Vue 3／Nuxt・Deno・Markdown・Bash／sh・zsh 向けの独自設定です。
Neovim 0.12 以上を使用します。初回起動では lazy.nvim、Mason、Treesitter がプラグイン・言語サーバー・parser を取得します。
`mise` の Node・Deno・Go・Rust・tree-sitter と C コンパイラが必要です。Rust は `rustfmt` と `clippy` も用意してください。
プロジェクトの依存は各プロジェクトで導入します。設定は依存パッケージを自動インストールしません。

Leader は **Space**。`Space ?` で操作一覧を表示します。旧キーバインドとの互換性はありません。

| 操作 | キー（Space の後） |
| --- | --- |
| ファイル／全文／バッファ検索 | `ff`／`fg`／`fb` |
| シンボル／診断検索 | `fs`／`fd` |
| Rename／Code action | `cr`／`ca` |
| 整形／import 整理／LSP 自動修正／lint | `cf`／`co`／`cx`／`cl` |
| check／test／run／中止／結果 | `tc`／`tt`／`tr`／`ts`／`tq` |
| Git status／blame／差分 | `gg`／`gb`／`gp` |
| バッファを閉じる／Yazi／Markdown プレビュー | `bd`／`e`／`mp` |
| 保存／終了／inlay hints 切替 | `w`／`q`／`uh` |

定義・参照・実装・型定義は `gd`・`gr`・`gi`・`gy`、説明は `K`。
診断の移動は `[d`・`]d`、実行結果の移動は `[q`・`]q`、バッファ切り替えは `Shift-h`・`Shift-l`。
`Ctrl-h/j/k/l` で分割ウィンドウ間を移動し、ターミナルでは Esc 2回で入力モードを抜けます。
補完は `Ctrl-n/p` で選択、`Ctrl-y` で確定、`Ctrl-e` で閉じます。Tab／Shift-Tab はスニペット内の移動です。
Enter は改行、`jj` は通常入力です。

保存時には対応する import 整理と整形を順に実行します。未使用 import が削除される場合があります。
各処理の上限は1秒で、失敗時は通知して保存を続けます。
Node 系の整形は設定のある Prettier → Biome → Oxfmt、lint は ESLint → Biome → Oxlint の順で一つを選びます。
未設定なら Node 系の自動整形・外部 lint は行いません。Biome・Oxc はプロジェクト内の実行ファイルが必要です。
Deno 設定と Node lockfile の近さで実行環境を判定し、同じディレクトリに Deno 設定がある場合は Deno が優先です。
Vue ファイルは vtsls＋vue_ls が担当します。Deno の TS・JS は denols と Deno formatter を使います。
zsh に Bash 用 LSP・ShellCheck・shfmt は適用しません。

タスクは実行前に変更済みバッファを保存します。Node 系は最寄りの package.json の `typecheck`／`test`／`dev` を使用し、
`packageManager` → 最寄りの lockfile → npm の順に選びます。型チェック script がなければローカルの `tsc`／`vue-tsc` を使用します。
Deno は同名 task を優先し、なければ現在ファイルの `deno check`／Deno ルートの `deno test` を実行します。
Rust は現在 crate の `cargo check/test/run`、Go は現在 package の `go vet .`／`go test .`／`go run .`。
Shell は方言に合う構文確認・実行、Markdown は lint・Leaf プレビューです。個別テスト実行とデバッガは含みません。
実行結果は Quickfix に表示します。check/test の同時実行はせず、`Space ts` で中止できます。

問題の切り分けは `:checkhealth`、`:Mason`、`:ConformInfo` を使用してください。
設定の回帰チェックはリポジトリルートで `nvim --headless -u NONE -l dotfiles/.config/nvim/tests/regression.lua` を実行します。

- dotfiles: `dotfiles/`
- mise 設定と管理対象: `mise.toml`
- セットアップスクリプト: `bootstrap.sh`

Herdr の `prefix+shift+g` は GWQ プラグインに割り当てています。既存ブランチの選択または新規ブランチ名の入力後、`gwq` で作成して Herdr のワークスペースとして開きます。`mise run init` がプラグインを自動リンクします。
