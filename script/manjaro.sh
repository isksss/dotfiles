#!/bin/bash
if ! grep -q "Manjaro Linux" /etc/os-release > /dev/null 2>&1; then
    echo "This script is only for Manjaro Linux"
    exit 1
fi

# install
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
    fcitx5 fcitx5-mozc fcitx5-configtool \
    yay \
    xclip \

yay -Syu
yay -S --needed --noconfirm \
    ttf-hackgen \
    google-chrome \
    visual-studio-code-bin