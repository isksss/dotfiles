#!/usr/bin/env bash

## Arch Linuxの初期設定スクリプト

# Variables
DOTFILES_DIR="$HOME/dotfiles"

# Functions

## パッケージのインストール

### パッケージのインストール
function install_packages() {
    sudo pacman -Syy
    echo "Install packages"
    sudo pacman -S --noconfirm --needed \
        curl \
        neovim \
        docker \
        git \
        go \
        jq \
        tmux \
        zsh \
        xclip \
}

### AURパッケージのインストール
#### yayのインストール
function install_yay() {
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    makepkg -si
    cd .. || exit
    rm -rf yay
}

#### AURパッケージのインストール
function install_aur_packages() {
    yay -S --noconfirm --needed \
        google-chrome \
        visual-studio-code-bin \
}

## シェルの切り替え to zsh
function change_shell() {
    chsh -s /bin/zsh
}

## main ########################################################
function main() {
    install_packages
    install_yay
    install_aur_packages
    change_shell
}

main
