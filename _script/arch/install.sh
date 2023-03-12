#!/bin/sh
set -e

if [ "$(uname)"!= "Linux"];then
    exit 1
fi

pacman -Syy

pacman -S sudo --noconfirm
pacman -S which --noconfirm
# pacman

pacman -S git --noconfirm
pacman -S zsh --noconfirm
pacman -S tree --noconfirm
pacman -S neovim --noconfirm
