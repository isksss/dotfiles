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

## 設定

- dotfiles: `dotfiles/`
- mise 設定と管理対象: `mise.toml`
- セットアップスクリプト: `bootstrap.sh`
