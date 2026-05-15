# [dotfiles](https://github.com/isksss/dotfiles)

Nix + Home Manager で管理している個人用 dotfiles です。

## 対応OS（優先）

- WSL Ubuntu
- Arch Linux

## セットアップ

### 1. Nix をインストール

- 公式インストーラで `nix` を導入します。

### 2. Home Manager を flake 経由で適用

```sh
# WSL Ubuntu
nix run home-manager/master -- switch --flake .#ubuntu

# Arch Linux
nix run home-manager/master -- switch --flake .#arch
```

## 管理方針

- 旧運用の `chezmoi` / `mise` は利用しません。
- ツールやランタイムは Nix で一元管理します。
