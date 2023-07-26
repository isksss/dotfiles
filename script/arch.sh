#!/usr/bin/env bash

# Arch Linuxか確認
if ! grep -q "Arch Linux" /etc/os-release > /dev/null 2>&1; then
    echo "This script is only for Arch Linux"
    exit 1
fi

# pacman update
sudo pacman -Syu

sudo pacman -S --needed --noconfirm \
    make \
    go \
    vim

if ! command -v yay;then
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
fi

yay -S --noconfirm \
    ttf-hackgen

# GUIセットアップ
sudo pacman -S xorg-xwayland qt5-wayland