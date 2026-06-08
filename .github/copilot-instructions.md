# Copilot Instructions

## リポジトリ概要

このリポジトリは [rhysd/dotfiles](https://github.com/rhysd/dotfiles)
形式で管理される dotfiles リポジトリです。`home/` 配下の実ファイルを
`.dotfiles/mappings.json` で `~` に symlink します。

## 主要コマンド

```sh
dotfiles link --dry   # 適用前にリンク内容を確認
dotfiles link         # symlink を作成
dotfiles clean        # 作成済みリンクを削除
dotfiles update       # dotfiles repo を更新
mise install          # mise.toml で定義されたツールとランタイムをインストール
```

## アーキテクチャ

### ツールとランタイム管理

`mise` が CLI ツールと言語ランタイムを管理します。次の 2 つの設定ファイルは同期を保つ必要があります。

- `mise.toml` - リポジトリルート
- `mise.toml` - `~/.config/mise/mise.toml`

### AI エージェント指示

グローバルな AI アシスタント指示の正本は `.agents/AGENTS.md` です。各 AI ツール向けの設定は実ファイルとして配置します。

- `.agents/AGENTS.md` -> `~/.agents/AGENTS.md`
- `.agents/AGENTS.md` -> `~/.codex/AGENTS.md`
- `.agents/AGENTS.md` -> `~/.copilot/copilot-instructions.md`
- `.agents/skills/...` -> `~/.agents/skills/...`
- `.agents/skills/...` -> `~/.codex/skills/...`
- `.github/agents/...` -> `~/.github/agents/...`

グローバルな AI の挙動を変更する場合は、`.agents/AGENTS.md` を編集します。
Codex skill は `research`、`implement`、`review`、`commit`、`branch`、
`merge-request` に統一します。GitHub Copilot では `.github/agents/` の
薄い wrapper を利用します。

### シェル設定

- `home/.zshenv` -> `~/.zshenv`: XDG 変数、`ZDOTDIR`、`PATH`、mise の有効化
- `home/dot_config/zsh` -> `~/.config/zsh`: エイリアス、補完、各種ツール初期化、scripts

`.zshrc` 内のツール初期化はすべて `command -v <tool> >/dev/null 2>&1` チェックでガードされています。

### 業務用と私用の環境差分

業務向けの挙動は `~/.config/zsh/local.zsh`（dotfiles 管理外）にある `ISWORK` 環境変数で制御します。

### Neovim 設定

エントリポイントは `home/dot_config/nvim/init.lua` で、
`config.options`、`config.keymaps`、`config.lazy` を読み込みます。

各機能は `lua/config/` 配下のモジュールとして分割されています。

- `lazy.lua` - プラグインマネージャー（lazy.nvim）と全プラグイン定義
- `lsp.lua` - mason-lspconfig 経由の LSP（gopls, rust_analyzer, ts_ls, vue_ls, jdtls）
- `format.lua` - conform.nvim（BufWritePre で実行）
- `lint.lua` - nvim-lint
- `ddc.lua` - 補完（Shougo/ddc.vim with denops）
- `ddu.lua` - ファジーファインダー / ファイラー（Shougo/ddu.vim with denops）
