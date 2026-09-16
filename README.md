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

- dotfiles: `dotfiles/`
- mise 設定と管理対象: `mise.toml`
- セットアップスクリプト: `bootstrap.sh`
