#!/bin/sh
DOTFILES_DIR=$(cd $(dirname $0); pwd)

cd $DOTFILES_DIR

####################
# create link
####################
ln -sf $DOTFILES_DIR/.zshrc $HOME/.zshrc

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