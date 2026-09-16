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

pi内では `/model` で `gpt-6-astra`、`/thinking` で `low` を確認できます。

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

## 設定

- dotfiles: `dotfiles/`
- mise 設定と管理対象: `mise.toml`
- セットアップスクリプト: `bootstrap.sh`
