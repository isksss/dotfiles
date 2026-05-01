# [dotfiles](https://github.com/isksss/dotfiles)

`chezmoi` で管理している個人用 dotfiles です。

## 使用ツール

- [chezmoi](https://www.chezmoi.io/): dotfiles の配置と適用
- [mise](https://github.com/jdx/mise): CLI ツールと言語ランタイムの管理

## セットアップ

適用前に差分を確認してから反映します。

```sh
chezmoi diff
chezmoi apply
mise install
```

## 管理している dotfiles

| chezmoi source                             | 適用先                               | 内容                                                                         |
| ------------------------------------------ | ------------------------------------ | ---------------------------------------------------------------------------- |
| `home/dot_zshenv`                          | `~/.zshenv`                          | XDG 環境変数、`ZDOTDIR`、`PATH`、`EDITOR`、`STARSHIP_CONFIG`                 |
| `home/dot_config/zsh/dot_zprofile`         | `~/.config/zsh/.zprofile`            | zsh profile                                                                  |
| `home/dot_config/zsh/dot_zshrc`            | `~/.config/zsh/.zshrc`               | zsh オプション、履歴設定、alias、mise/zoxide/fzf/atuin/starship などの初期化 |
| `home/dot_bashrc`                          | `~/.bashrc`                          | bash での mise 初期化                                                        |
| `home/dot_config/mise/config.toml`         | `~/.config/mise/config.toml`         | CLI ツール、言語ランタイム、shell alias、環境変数                            |
| `home/dot_config/nvim`                     | `~/.config/nvim`                     | Neovim 設定                                                                  |
| `home/dot_config/starship.toml`            | `~/.config/starship.toml`            | Starship prompt 設定                                                         |
| `home/dot_config/zellij/config.kdl`        | `~/.config/zellij/config.kdl`        | Zellij 設定                                                                  |
| `home/dot_config/alacritty/alacritty.toml` | `~/.config/alacritty/alacritty.toml` | Alacritty フォント設定                                                       |
| `home/dot_config/lazygit/config.yml`       | `~/.config/lazygit/config.yml`       | Lazygit keybinding                                                           |
| `home/dot_config/atuin/config.toml`        | `~/.config/atuin/config.toml`        | Atuin 設定                                                                   |
| `home/dot_config/ghq/config.yml`           | `~/.config/ghq/config.yml`           | ghq 設定                                                                     |
| `home/dot_config/git/ignore`               | `~/.config/git/ignore`               | グローバル gitignore                                                         |
| `home/dot_config/Code/User/settings.json`  | `~/.config/Code/User/settings.json`  | VS Code user settings                                                        |

## Neovim 設定

`home/dot_config/nvim` 配下で管理しています。

- `init.lua`: エントリポイント
- `lua/config/lazy.lua`: plugin manager
- `lua/config/options.lua`: 基本オプション
- `lua/config/keymaps.lua`: キーマップ
- `lua/config/lsp.lua`: LSP
- `lua/config/format.lua`: format
- `lua/config/lint.lua`: lint
- `lua/config/ddc.lua`: completion
- `lua/config/ddu.lua`: filer / picker
- `lua/config/fzf.lua`: fzf
- `lua/config/git.lua`: git integration
- `lua/config/neo-tree.lua`: neo-tree
- `lua/config/tabs.lua`: tab settings
- `lazy-lock.json`: plugin lockfile

## 日常的な操作

```sh
chezmoi status
chezmoi diff
chezmoi apply
```

設定ファイルを追加する場合は、`home/` 配下に chezmoi の source state として配置します。
例: `~/.config/example/config.toml` は `home/dot_config/example/config.toml` に置きます。

## 管理対象外

- `zsh/zsh.d/local.zsh`: ローカル環境ごとの zsh 設定
- `zsh/zsh.d/.zcompdump`: zsh の補完キャッシュ
- `powershell/profile.ps1`: Windows 用 PowerShell profile
