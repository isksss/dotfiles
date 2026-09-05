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

## pi + llama.cpp

設定を反映します。既存の `~/.pi/agent/settings.json` がある場合は、内容を確認して
から `--force` を付けてください。

```sh
mise dotfiles apply --force
```

モデルを読み込むサーバーを起動します。

```sh
mise run llama-pi-server
```

別のターミナルで `pi` を起動します。`~/.cache/llmfit/models` にある
`Qwen2.5-Coder-7B-Instruct-Q8_0.gguf` を利用できます。既定モデルは設定していません。

初回は pi で `/login llama.cpp` を実行し、サーバー URL に
`http://127.0.0.1:8080` を入力してください。API key は空のまま Enter で進み、
`/llama` で Qwen モデルをロードした後、`/model` で選択します。サーバーは `127.0.0.1:8080` の
ローカルからのみ接続できます。すでに同じポートで `llama-server -m` を起動して
いる場合は、先にそのプロセスを終了してください。終了する場合は
`llama-pi-server` を実行しているターミナルで `Ctrl-C` を押します。

OpenCode から使う場合は、同じサーバーを起動した状態でモデルを指定して起動します。

```sh
opencode -m llama.cpp/Qwen2.5-Coder-7B-Instruct-Q8_0
```

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
