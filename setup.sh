#!/bin/sh
############################################################
# Setup Shell Script
############################################################
echo "#############################################"
echo "#            Setup Shell Script             #"
echo "#############################################"

export DOTFILES=$(cd $(dirname $0); pwd)
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache

echo "dotfiles_dir: $DOTFILES"

chmod -R +x $DOTFILES/_script/*
chmod -R +x $DOTFILES/_bin/*

##############################
# for ArchLinux
$DOTFILES/_script/arch/install.sh

##############################
# for Mac

##############################
# for ALL OS
$DOTFILES/_script/app.sh

$DOTFILES/_script/common/install.sh

# make project dir
if [ ! -d "$HOME/workspace" ]; then
    mkdir -p $HOME/workspace
fi


