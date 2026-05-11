# Copilot Instructions

## リポジトリ概要

このリポジトリは [chezmoi](https://www.chezmoi.io/) で管理される dotfiles リポジトリです。ソースルートは `home/`（`.chezmoiroot` で定義）です。

## chezmoi の命名規則

`home/` 配下のファイルは、chezmoi のソース命名規則に従います。

| ソース名             | 配置先                                                    |
| -------------------- | --------------------------------------------------------- |
| `dot_foo`            | `.foo`                                                    |
| `dot_config/bar`     | `~/.config/bar`                                           |
| `foo.tmpl`           | `foo`（Go テンプレート。apply 時に処理される）            |
| `.chezmoitemplates/` | `{{- template "Name" . }}` で参照される共有テンプレート群 |

新しい dotfile（例: `~/.config/example/config.toml`）を追加する場合は、`home/dot_config/example/config.toml` に配置してください。

## 主要コマンド

```sh
chezmoi diff        # 適用前に変更内容を確認
chezmoi apply       # ソース状態をホームディレクトリへ適用
chezmoi status      # 差分のあるファイルを表示
mise install        # mise.toml で定義されたツールとランタイムをインストール
```

## アーキテクチャ

### ツールとランタイム管理

`mise` がすべての CLI ツールと言語ランタイムを管理します。次の 2 つの設定ファイルは同期を保つ必要があります。

- `mise.toml` — リポジトリルート（このリポジトリ内で作業するときに使用）
- `home/dot_config/mise/config.toml` — `~/.config/mise/config.toml` として配備

### AI エージェント指示

`home/.chezmoitemplates/AGENTS.md` は、グローバルな AI アシスタント指示の **唯一の正本（single source of truth）** です。各 AI ツール向けの chezmoi テンプレートから参照されます。

- `home/dot_claude/CLAUDE.md.tmpl` → `~/.claude/CLAUDE.md`
- `home/dot_copilot/copilot-instructions.md.tmpl` → `~/.copilot/copilot-instructions.md`
- `home/dot_codex/AGENTS.md.tmpl` → `~/.codex/AGENTS.md`

グローバルな AI の挙動を変更する場合は、`home/.chezmoitemplates/AGENTS.md` を編集し、その後 `chezmoi apply` を実行してください。

### シェル設定

- `home/dot_zshenv` → `~/.zshenv`: XDG 変数、`ZDOTDIR`、`PATH`、mise の有効化
- `home/dot_config/zsh/dot_zshrc` → `~/.config/zsh/.zshrc`: エイリアス、補完、各種ツール初期化
- `home/dot_config/zsh/dot_zprofile` → `~/.config/zsh/.zprofile`: ログインシェル向け設定

`.zshrc` 内のツール初期化はすべて `command -v <tool> >/dev/null 2>&1` チェックでガードされています。

### 業務用と私用の環境差分

業務向けの挙動は `~/.config/zsh/local.zsh`（chezmoi 管理外）にある `ISWORK` 環境変数で制御します。`ISWORK` が未設定の場合は、1Password（`op`）を使って SSH キーを自動ロードします。

### Neovim 設定

エントリポイントは `home/dot_config/nvim/init.lua` で、`config.options`、`config.keymaps`、`config.lazy` を読み込みます。

各機能は `lua/config/` 配下のモジュールとして分割されています。

- `lazy.lua` — プラグインマネージャー（lazy.nvim）と全プラグイン定義
- `lsp.lua` — mason-lspconfig 経由の LSP（gopls, rust_analyzer, ts_ls, vue_ls, jdtls）
- `format.lua` — conform.nvim（BufWritePre で実行）
- `lint.lua` — nvim-lint
- `ddc.lua` — 補完（Shougo/ddc.vim with denops）
- `ddu.lua` — ファジーファインダー / ファイラー（Shougo/ddu.vim with denops）
