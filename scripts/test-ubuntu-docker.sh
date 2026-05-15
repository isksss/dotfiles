#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
IMAGE_NAME="dotfiles-ubuntu-home-manager-test"

printf 'Dockerイメージをビルドします...\n'
docker build -t "$IMAGE_NAME" -f "$REPO_ROOT/docker/ubuntu-home-manager/Dockerfile" "$REPO_ROOT"

printf 'Home Managerの適用と検証コマンドを実行します...\n'
docker run --rm -it \
  -v "$REPO_ROOT:/workspace/dotfiles" \
  "$IMAGE_NAME" \
  bash -lc '
    set -euo pipefail
    source /home/tester/.nix-profile/etc/profile.d/nix.sh

    nix run home-manager/master -- switch --flake .#ubuntu

    command -v nvim zellij lazygit rg fzf
    echo "$ZDOTDIR"
    test "$ZDOTDIR" = "$HOME/.config/zsh"
    test -f "$HOME/.config/zsh/.zshrc"
    test -f "$HOME/.config/zsh/.zprofile"
    test -f "$HOME/.zshenv"

    echo "検証完了: 必須コマンドとzsh設定ファイルを確認しました。"
  '
