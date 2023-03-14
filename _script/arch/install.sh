#!/bin/sh
set -e

if [ "$(uname)" != "Linux" ];then
    exit 1
fi

if [ ! $(which pacman) ]; then
    exit 1
fi

# pacman --noconfirm -Syy

pacman --noconfirm -S sudo
pacman --noconfirm -S which

pacman --noconfirm -S git
pacman --noconfirm -S zsh
pacman --noconfirm -S tree
pacman --noconfirm -S neovim
pacman --noconfirm -S xclip
pacman --noconfirm -S github-cli

pacman --noconfirm -S vivaldi

pacman --noconfirm -S ttf-sazanami
pacman --noconfirm -S otf-ipafont otf-ipamjfont