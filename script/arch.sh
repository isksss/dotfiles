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
    exa

# yay
git clone https://aur.archlinux.org/yay.git
cd yay || exit 1
makepkg -si --noconfirm
cd .. || exit 1
rm -rf yay

# yay update
yay -Syu
yay -S --needed --noconfirm \
    ttf-hackgen
