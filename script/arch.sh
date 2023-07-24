#!/usr/bin/env bash

# Arch Linuxか確認
if ! grep -q "Arch Linux" /etc/os-release > /dev/null 2>&1; then
    echo "This script is only for Arch Linux"
    exit 1
fi

# pacman update
sudo pacman -Syu

sudo pacman -S --needed --noconfirm \
    git \
    zsh \
    make \
    go \
    bat \
    exa \
    alacritty \
    vim \
    neovim \

# yay
if ! command -v yay &>/dev/null ; then
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit 1
    makepkg -si --noconfirm
    cd .. || exit 1
    rm -rf yay
fi

# yay update
yay -Syu
yay -S --needed --noconfirm \
    ttf-hackgen \
    google-chrome \
    visual-studio-code-bin

# volta
curl https://get.volta.sh | bash
volta install node@latest

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# starship
sudo pacman -S --noconfirm starship