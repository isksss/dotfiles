#!/bin/sh
DOTFILES_DIR=$(cd $(dirname $0); pwd)

cd $DOTFILES_DIR
XDG_CONFIG_HOME
####################
# create link
####################
ln -sf $DOTFILES_DIR/.zshrc $HOME/.zshrc # zsh
ln -sf $DOTFILES_DIR/.zshrc $HOME/.zshenv # zsh

mkdir -p $HOME/.config
ln -sf $DOTFILES_DIR/.config/nvim/ $HOME/.config/nvim # nvim

####################
# zshrc
####################
source $HOME/.zshrc

####################
# OS
####################

# +x
chmod +x ./installer/*

./installer/mac.sh