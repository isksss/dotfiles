# [dotfiles](https://github.com/isksss/dotfiles)

`chezmoi` で管理している個人用 dotfiles です。

## 使用ツール

- [chezmoi](https://www.chezmoi.io/): dotfiles の配置と適用
- [mise](https://github.com/jdx/mise): CLI ツールと言語ランタイムの管理

```sh
# miseをinstall
curl https://mise.run | sh
# dotfilesをセットアップ
"$HOME/.local/bin/mise" exec chezmoi@latest -- "chezmoi init --apply isksss && mise up"
```

## セットアップ

適用前に差分を確認してから反映します。

```sh
chezmoi diff
chezmoi apply
mise install
```

## Dockerでの検証手順

Ubuntu 24.04 コンテナ上で Home Manager を適用し、主要コマンド・zsh設定の配置をまとめて検証できます。

```sh
./scripts/test-ubuntu-docker.sh
```
