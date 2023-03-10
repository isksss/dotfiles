#!/bin/sh
############################################################
# Setup Shell Script
############################################################
export DOTFILES=$(cd $(dirname $0); pwd)
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
chmod -R +x $DOTFILES/_script/*

echo $DOTFILES
##############################
# for ArchLinux
$DOTFILES/_script/arch/install.sh

##############################
# for Mac

##############################
# for ALL OS
$DOTFILES/_script/app.sh


