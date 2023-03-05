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
if [ ! -d $HOME/.zsh ]; then
    mkdir -p $HOME/.zsh
    ln -sf $DOTFILES/zsh/.zsh/.zsh_aliases $HOME/.zsh/.zsh_aliases
    ln -sf $DOTFILES/zsh/.zsh/.zsh_path $HOME/.zsh/.zsh_path
    ln -sf $DOTFILES/zsh/.zsh/.zsh_plugins $HOME/.zsh/.zsh_plugins
fi

### nvim
if [ ! -d $XDG_CONFIG_HOME/nvim ]; then
    echo 'make dir: nvim'
    mkdir -p $XDG_CONFIG_HOME/nvim
fi

if [ ! -d $XDG_CONFIG_HOME/nvim/toml ]; then
    echo 'make dir: nvim/toml'
    mkdir -p $XDG_CONFIG_HOME/nvim/toml
fi

NVIM_DIR=$DOTFILES/.config/nvim
NVIM_HOME=$XDG_CONFIG_HOME/nvim

ln -sf $NVIM_DIR/init.vim $NVIM_HOME/init.vim
ln -sf $NVIM_DIR/toml/dein.toml $NVIM_HOME/toml/dein.toml
ln -sf $NVIM_DIR/toml/lazy.toml $NVIM_HOME/toml/lazy.toml
ln -sf $NVIM_DIR/coc-settings.json $NVIM_HOME/coc-settings.json

## link
ln -sf $DOTFILES/git/.gitignore_global $HOME/.gitignore_global
if [ $(uname) != "Darwin" ]; then
  ln -sf $DOTFILES/git/.gitconfig $HOME/.gitconfig
fi

## args
# while (( $# > 0 ))
# do
#   case $1 in
#     # ...
#     -i | --install)
#       INSTALL=1
#       $DOTFILES/installer/_installer.sh
#       ;;
#     # ...
#   esac
#   shift
# done
