#!/bin/sh
## env
export DOTFILES=$(cd $(dirname $0); pwd)

XDG_CONFIG_HOME=$HOME/.config
XDG_CACHE_HOME=$HOME/.cache

## add +x
chmod +x $DOTFILES/script/*
chmod +x $DOTFILES/installer/*

## ln
ln -sf $DOTFILES/zsh/.zshrc $HOME/.zshrc
ln -sf $DOTFILES/zsh/.zshenv $HOME/.zshenv
ln -sf $DOTFILES/zsh/.zsh $HOME/.zsh

### nvim
if [ ! -d $XDG_CONFIG_HOME/nvim ]; then
    echo 'make dir: nvim'
    mkdir $XDG_CONFIG_HOME/nvim
fi

if [ ! -d $XDG_CONFIG_HOME/nvim/toml ]; then
    echo 'make dir: nvim/toml'
    mkdir $XDG_CONFIG_HOME/nvim/toml
fi

NVIM_DIR=$DOTFILES/.config/nvim
NVIM_HOME=$XDG_CONFIG_HOME/nvim

ln -sf $NVIM_DIR/init.vim $NVIM_HOME/init.vim
ln -sf $NVIM_DIR/toml/dein.toml $NVIM_HOME/toml/dein.toml
ln -sf $NVIM_DIR/toml/lazy.toml $NVIM_HOME/toml/lazy.toml

## link
ln -sf $DOTFILES/git/.gitignore_global $HOME/.gitignore_global

## args
while (( $# > 0 ))
do
  case $1 in
    # ...
    -i | --install)
      INSTALL=1
      $DOTFILES/installer/_installer.sh
      ;;
    # ...
  esac
  shift
done
