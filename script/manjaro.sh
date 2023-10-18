#!/bin/bash

sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm \
    git \
    curl \
    zsh \ 
    neovim \
    starship \
    yay

# yay
yay -S --noconfirm \
    google-chrome \
    visual-studio-code-bin \
    ttf-hackgen