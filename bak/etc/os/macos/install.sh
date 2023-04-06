#!/usr/bin/env bash

## MacOSの初期設定スクリプト

## Variables
DOTFILES_DIR="$HOME/dotfiles"

## Functions

### Homebrewのインストール
function install_homebrew() {

    # Homebrewがインストールされているか確認
    if type brew > /dev/null 2>&1; then
        echo "Homebrew is already installed"
        return
    fi

    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

### Homebrewのパッケージのインストール
function install_brew_packages() {
    brew install \
        curl \
        git \
        go \
        jq \
        tmux \
        zsh
}

### HomebrewのパッケージをBrewfileからインストール
function install_brew_packages_from_brewfile() {
    brew bundle --file="$DOTFILES_DIR/etc/os/macos/Brewfile"
}

### Brewfileの更新
function update_brewfile() {
    brew bundle dump --file="$DOTFILES_DIR/etc/os/macos/Brewfile"
}

### シェルの切り替え to zsh
function change_shell() {
    # シェルがzshになっているか確認
    if [ "$SHELL" = "/bin/zsh" ]; then
        echo "Shell is already zsh"
        return
    fi
    chsh -s /bin/zsh
}

### main ########################################################
function main() {
    install_homebrew
    install_brew_packages_from_brewfile
    change_shell
}

main