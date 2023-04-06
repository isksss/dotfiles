#!/usr/bin/env bash

# variables
export DOTFILES="$HOME/dotfiles"
export WORKSPACE="$HOME/workspace"
export XDG_CONFIG_HOME="$HOME/.config" 

# source
source "$DOTFILES/etc/util/colors.sh"
source "$DOTFILES/etc/util/check.sh"

function zsh_link(){
    ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
    ln -sf "$DOTFILES/zsh/.zshenv" "$HOME/.zshenv"
    ln -sf "$DOTFILES/zsh/.zsh" "$HOME/.zsh"
}

function git_link(){
    mkdir -p $XDG_CONFIG_HOME/git
    ln -sf "$DOTFILES/git/.gitconfig" "$XDG_CONFIG_HOME/git/config"
    ln -sf "$DOTFILES/git/.gitignore" "$XDG_CONFIG_HOME/git/ignore"
}

function main(){
    zsh_link
    git_link
}

main