# [dotfiles](https://github.com/isksss/dotfiles)

`rhysd/dotfiles` で symlink 管理している個人用 dotfiles です。

## 使用ツール

- [dotfiles](https://github.com/rhysd/dotfiles): dotfiles の配置と symlink 管理
- [mise](https://github.com/jdx/mise): CLI ツールと言語ランタイムの管理

## セットアップ

Arch Linux を主対象とし、Ubuntu と macOS は best-effort で扱います。Windows と PowerShell は対象外です。

`git` と `curl` を用意したうえで、外部から bootstrap を実行します。既定では `~/dotfiles` に clone し、link の dry-run を表示してから symlink 作成と `mise install` まで実行します。

```sh
curl -fsSL https://raw.githubusercontent.com/isksss/dotfiles/main/bootstrap.sh | sh
```

`bootstrap.sh` は `mise` がなければ `mise.run` から導入します。

`mise install` は GitHub API でツール情報を取得します。rate limit の 403 が出る場合は [mise の案内](https://mise.jdx.dev/dev-tools/github-tokens.html) に従い、`MISE_GITHUB_TOKEN` または `GITHUB_TOKEN` を設定して再実行します。

Neovim plugin は lazy.nvim、LSP server、formatter、linter は Mason で管理します。plugin 更新は Neovim で `:Lazy update`、Mason package の更新は `:MasonUpdate` を実行します。

clone 先を変える場合は `DOTFILES_DIR` を指定します。

```sh
curl -fsSL https://raw.githubusercontent.com/isksss/dotfiles/main/bootstrap.sh | DOTFILES_DIR="$HOME/src/dotfiles" sh
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

## ローカル LLM

opencode は Ollama の OpenAI-compatible API を使う設定を `home/dot_config/opencode/opencode.jsonc` で管理します。このマシンでは WSL2 側のメモリと RTX 4060 Ti 8GB に合わせて、既定を `qwen2.5-coder:7b-opencode`、軽量処理用を `qwen2.5-coder:3b-opencode` にしています。

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

このリポジトリの AI エージェント規約は Codex での利用を主軸にし、`.agents/` 配下を正本として管理します。

- `.agents/AGENTS.md`: グローバル指示の正本
- `.agents/skills/`: `develop`、`research`、`implement`、`review`、`commit`、`branch`、`merge-request`、`grill-me`、`herdr` などの作業 skill
- `.github/agents/`: GitHub Copilot 向けの薄い wrapper
- `skills-lock.json`: 外部 skill の取得元と version 情報

`.dotfiles/mappings.json` では、`.agents/AGENTS.md` と `.agents/skills/` を `~/.codex` と `~/.agents` へ配布します。opencode 向けには `~/.config/opencode/AGENTS.md` と `~/.config/opencode/skills` へも配布します。`~/.copilot` や `~/.claude` への配布は既存環境との互換目的で残しています。

明確な変更依頼は `develop` が調査、実装、レビュー、検証まで進めます。調査、レビュー、Git 操作など単一目的では対応する個別 skill を使います。自作 skill だけを Git 管理し、外部 skill の本体は `skills-lock.json` を基に導入します。

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
