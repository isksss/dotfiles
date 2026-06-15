# [dotfiles](https://github.com/isksss/dotfiles)

`rhysd/dotfiles` で symlink 管理している個人用 dotfiles です。

## 使用ツール

- [dotfiles](https://github.com/rhysd/dotfiles): dotfiles の配置と symlink 管理
- [mise](https://github.com/jdx/mise): CLI ツールと言語ランタイムの管理

## セットアップ

`git` を用意したうえで、外部から bootstrap を実行します。Unix 側は `curl` も使います。既定では `~/dotfiles` に clone し、link の dry-run を表示してから symlink 作成と `mise install` まで実行します。

### Unix

```sh
curl -fsSL https://raw.githubusercontent.com/isksss/dotfiles/main/bootstrap.sh | sh
```

### Windows

```powershell
irm https://raw.githubusercontent.com/isksss/dotfiles/main/bootstrap.ps1 | iex
```

`bootstrap.sh` は `mise` がなければ `mise.run` から導入します。`bootstrap.ps1` は `mise` がなければ Scoop を優先し、Scoop がない場合は winget を使います。

`mise install` は GitHub API でツール情報を取得します。rate limit の 403 が出る場合は [mise の案内](https://mise.jdx.dev/dev-tools/github-tokens.html) に従い、`MISE_GITHUB_TOKEN` または `GITHUB_TOKEN` を設定して再実行します。

Neovim の LSP server、formatter、linter は Mason で管理します。dpp は不足プラグインを自動導入します。プラグイン更新は Neovim で `:DppUpdate` を実行します。直前の更新へ戻す場合は `:DppRollbackLatest` を実行します。

clone 先を変える場合は `DOTFILES_DIR` を指定します。

```sh
curl -fsSL https://raw.githubusercontent.com/isksss/dotfiles/main/bootstrap.sh | DOTFILES_DIR="$HOME/src/dotfiles" sh
```

```powershell
$env:DOTFILES_DIR = "$HOME\src\dotfiles"
irm https://raw.githubusercontent.com/isksss/dotfiles/main/bootstrap.ps1 | iex
```

既定の clone 先にこのリポジトリがある場合は再利用します。別のディレクトリや別 origin の checkout がある場合は上書きせず停止します。

手動で進める場合は次の手順です。

```sh
go install github.com/rhysd/dotfiles@latest
dotfiles clone isksss/dotfiles
cd dotfiles
dotfiles link --dry
dotfiles link
mise install
```

`dotfiles` は `.dotfiles/mappings.json` を読み、`home/` 配下の実ファイルをホームディレクトリへ symlink します。

## 日常的な操作

```sh
dotfiles list
dotfiles link --dry
dotfiles link
dotfiles clean
dotfiles update
```

## AI エージェント規約

このリポジトリの AI エージェント規約は Codex での利用を主軸にし、`.agents/` 配下を正本として管理します。

- `.agents/AGENTS.md`: グローバル指示の正本
- `.agents/rules/`: 共通ルールと詳細参照
- `.agents/skills/`: `research`、`implement`、`review`、`commit`、`branch`、`merge-request`、`grill-me`、`herdr` などの作業 skill
- `.agents/templates/`: 回答や作業報告のテンプレート
- `.github/agents/`: GitHub Copilot 向けの薄い wrapper

`.dotfiles/mappings.json` では、`.agents/AGENTS.md`、`.agents/rules/`、`.agents/skills/`、`.agents/templates/` を `~/.codex` と `~/.agents` へ配布します。`~/.copilot` や `~/.claude` への配布は既存環境との互換目的で残しています。

AI 規約を変更する場合は、まず `.agents/` 配下の正本を更新し、必要に応じて `.github/agents/` や `.github/copilot-instructions.md` の参照だけを調整します。

## Herdr

Herdr の設定は `home/dot_config/herdr/config.toml` で管理し、`dotfiles link` で `~/.config/herdr/config.toml` に配置します。稼働中の Herdr に反映する場合は次を実行します。

```sh
herdr server reload-config
```

Codex の Herdr integration hook は Herdr 側の生成物として扱い、dotfiles 管理には含めません。必要な環境では次を実行します。

```sh
herdr integration install codex
```

## 管理対象外

- `home/dot_config/git/config.work`: 個人・業務別の追加 gitconfig
- `home/dot_config/zsh/local.zsh`: ローカル環境ごとの zsh 設定
- `home/dot_config/nvim/lua/local/`: 個人環境依存の Neovim 設定。Git 管理対象外。`example.lua` を参考に必要な local 設定を配置する
- `.env` / `.env.*`: 環境変数ファイル
