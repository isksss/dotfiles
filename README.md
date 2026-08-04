# [dotfiles](https://github.com/isksss/dotfiles)

`mise` で symlink 管理している個人用 dotfiles です。

## 使用ツール

- [mise](https://github.com/jdx/mise): dotfiles、CLI ツール、言語ランタイムの管理

## セットアップ

Arch Linux を主対象とし、Ubuntu と macOS は best-effort で扱います。Windows と PowerShell は対象外です。

`git` と `curl` を用意したうえで、外部から bootstrap を実行します。`~/dotfiles` に clone し、dotfiles の dry-run、競合ファイルの退避、symlink 作成、tool install まで実行します。

```sh
curl -fsSL https://raw.githubusercontent.com/isksss/dotfiles/main/bootstrap.sh | sh
```

`bootstrap.sh` は公式 installer (`mise.run`) 版を `~/.local/bin/mise` に導入します。mise 本体は `mise self-update`、mise 管理 tool は `mise upgrade` で更新します。

`mise install` は GitHub API でツール情報を取得します。rate limit の 403 が出る場合は [mise の案内](https://mise.jdx.dev/dev-tools/github-tokens.html) に従い、`MISE_GITHUB_TOKEN` または `GITHUB_TOKEN` を設定して再実行します。

Neovim plugin は lazy.nvim、LSP server、formatter、linter は Mason で管理します。plugin 更新は Neovim で `:Lazy update`、Mason package の更新は `:MasonUpdate` を実行します。Mason が配布 archive を展開できるよう、ホストには `unzip` も用意します。

clone 先は `~/dotfiles` 固定です。既存 checkout は再利用し、別 origin や Git checkout ではない場合は上書きせず停止します。競合 target は `~/.local/state/dotfiles-backups/<timestamp>/` に退避します。

手動で進める場合は次の手順です。

```sh
git clone https://github.com/isksss/dotfiles.git ~/dotfiles
cd ~/dotfiles
mise trust mise.toml
mise dotfiles apply --dry-run --verbose --force
mise bootstrap --yes
```

mise は `mise.toml` の `[dotfiles]` を読み、`dotfiles/` 配下の実ファイルをホームディレクトリへ symlink します。

## 日常的な操作

```sh
mise dotfiles status
mise dotfiles apply --dry-run --verbose
mise dotfiles apply
mise dotfiles edit ~/.zshenv
mise dotfiles add ~/.zshenv
```

OS package と mise 管理ツールは `update` で更新します。通常は更新だけを行い、不要 package、cache、古い mise tool version も削除する場合は `--cleanup` を付けます。実行内容だけを確認する場合は `--dry-run` を使います。

```sh
update
update --cleanup
update --dry-run
```

リポジトリの設定と skill は一括検証できます。

```sh
cd "$DOTFILES_REPO_PATH"
mise run check
```

## Shell と Neovim の設定

zsh は `dotfiles/.config/zsh/rc/` を起動順の責務別 module として管理します。標準 abbreviation は repo で管理し、対話的に追加した abbreviation と `local.zsh` はローカル設定として併用します。completion と `.zcompdump` は `${XDG_CACHE_HOME}/zsh` に生成されます。

Nushell は mise でインストールし、`nu` で起動します。`dotfiles/.config/nushell/` では mise、Starship、zoxide、Atuin の連携と共通 alias を設定します。各ツールが生成する Nushell 用コードは `${XDG_CACHE_HOME}/nushell/integrations/` に保存されます。

Neovim は `lua/config/` に共通処理、`lua/plugins/` に lazy.nvim の plugin spec を配置します。短い plugin 設定は spec に同居し、LSP、ddc、ddu、task runner などの複雑な処理は `lua/config/` の module に分離します。

リポジトリの `.env` は shell から自動では読み込みません。必要な場合は、信頼するプロジェクトの `mise.toml` に次を追加して `mise trust` を実行します。

```toml
[env]
_.file = ".env"
```

## ローカル LLM

opencode は Ollama の OpenAI-compatible API を使う設定を `dotfiles/.config/opencode/opencode.jsonc` で管理します。このマシンでは WSL2 側のメモリと RTX 4060 Ti 8GB に合わせて、既定を `qwen2.5-coder:7b-opencode`、軽量処理用を `qwen2.5-coder:3b-opencode` にしています。

Ollama server は systemd を使わず、必要なときに Herdr の別パネルで起動します。

```sh
ollama serve
```

初回またはモデル更新時は、別のシェルで次を実行します。

```sh
ollama pull qwen2.5-coder:7b
ollama pull qwen2.5-coder:3b
ollama create qwen2.5-coder:7b-opencode -f ~/.config/ollama/Modelfile.qwen2.5-coder-7b-opencode
ollama create qwen2.5-coder:3b-opencode -f ~/.config/ollama/Modelfile.qwen2.5-coder-3b-opencode
```

opencode 側の確認は次を使います。

```sh
opencode debug config
opencode models ollama
opencode run -m ollama/qwen2.5-coder:7b-opencode "READMEを要約して"
```

## AI エージェント規約

このリポジトリの AI エージェント規約は `.agents/` 配下を正本とし、Codex、GitHub Copilot、Claude Code で共通利用します。

- `.agents/AGENTS.md`: グローバル指示の正本
- `.agents/skills/`: `research`、`implement`、`review`、`commit`、`branch`、`merge-request` などの自作 skill
- `.github/agents/`: GitHub Copilot 向けの薄い wrapper
- `skills-lock.json`: 外部 skill の取得元と version 情報

`mise.toml` では `.agents/AGENTS.md` を次の各ツールのグローバル指示ファイルへ symlink し、内容を複製せずに共通化します。

- `~/.codex/AGENTS.md`: Codex
- `~/.copilot/copilot-instructions.md`: GitHub Copilot CLI
- `~/.claude/CLAUDE.md`: Claude Code と VS Code の Copilot Chat
- `~/.agents/AGENTS.md`: 共通エージェント規約の互換配置

自作 skill は `~/.agents/skills/<name>` へ個別に配布します。外部 skill は installer 側で管理し、設計の深掘りには共通の `grilling` skill を使います。Codex、opencode、Copilot、Claude 向けの複製は作りません。

作業前に利用可能な skill を確認し、目的に合う skill を使います。自作 skill だけを Git 管理し、外部 skill の本体は `skills-lock.json` を基に導入します。

AI 規約を変更する場合は、まず `.agents/` 配下の正本を更新し、必要に応じて `.github/agents/` や `.github/copilot-instructions.md` の参照だけを調整します。

### GitHub Copilot の Backlog MCP

Copilot CLI と VS Code の Copilot Chat では、ユーザー設定として Backlog MCP を利用できます。CLI の設定は `~/.copilot/mcp-config.json`、native Linux 版 VS Code の設定は `~/.config/Code/User/mcp.json` に配置され、どの workspace からでも有効です。

Backlog の接続情報は設定ファイルへ保存せず、Copilot を起動する process に次の環境変数を設定します。実値は Git 管理対象外の `~/.config/zsh/local.zsh` などで管理してください。

```sh
export BACKLOG_DOMAIN="your-space.backlog.com"
export BACKLOG_API_KEY="your-api-key"
```

設定後は新しい shell で Copilot CLI を起動し、VS Code は window を再読み込みします。CLI は `copilot mcp list`、VS Code は command palette の `MCP: List Servers` で `backlog` が認識されていることを確認できます。初回起動時は、表示される MCP server の trust 確認を行います。

WSL から Windows 版 VS Code を利用する場合、MCP 設定と環境変数は Windows 側のユーザープロファイルにも登録します。次のコマンドは、現在の WSL 環境変数を Windows ユーザー環境へ保存するため、実行後に VS Code を完全に終了して起動し直してください。

```sh
code --add-mcp '{"name":"backlog","type":"stdio","command":"wsl.exe","args":["-e","sh","-lc","exec \"$HOME/.local/share/mise/installs/node/24/bin/npx\" -y backlog-mcp-server"],"env":{"BACKLOG_DOMAIN":"${env:BACKLOG_DOMAIN}","BACKLOG_API_KEY":"${env:BACKLOG_API_KEY}"}}'
setx.exe BACKLOG_DOMAIN "$BACKLOG_DOMAIN"
setx.exe BACKLOG_API_KEY "$BACKLOG_API_KEY"
powershell.exe -NoProfile -Command '$current = [Environment]::GetEnvironmentVariable("WSLENV", "User"); $items = @($current -split ":" | Where-Object { $_ }); foreach ($name in @("BACKLOG_DOMAIN", "BACKLOG_API_KEY")) { if (-not ($items | Where-Object { ($_ -split "/")[0] -eq $name })) { $items += "$name/u" } }; [Environment]::SetEnvironmentVariable("WSLENV", ($items -join ":"), "User")'
```

## Herdr

Herdr の設定は `dotfiles/.config/herdr/config.toml` で管理し、mise で `~/.config/herdr` に配置します。稼働中の Herdr に反映する場合は次を実行します。

```sh
herdr server reload-config
```

Codex の Herdr integration hook は Herdr 側の生成物として扱い、dotfiles 管理には含めません。必要な環境では次を実行します。

```sh
herdr integration install codex
```

## 管理対象外

- `dotfiles/.config/git/config.work`: 個人・業務別の追加 gitconfig
- `dotfiles/.config/zsh/local.zsh`: ローカル環境ごとの zsh 設定
- `dotfiles/.config/nvim/lua/local/`: 個人環境依存の Neovim 設定。Git 管理対象外。`example.lua` を参考に必要な local 設定を配置する
- `.env` / `.env.*`: 環境変数ファイル
