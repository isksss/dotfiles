#!/usr/bin/env bash

# variables
export DOTFILES="$HOME/dotfiles"
export WORKSPACE="$HOME/workspace"
export XDG_CONFIG_HOME="$HOME/.config" 

# source
source "$DOTFILES/etc/util/colors.sh"
source "$DOTFILES/etc/util/check.sh"

function zsh_link(){
    local ZDOTDIR="$XDG_CONFIG_HOME/zsh"
    mkdir -p $ZDOTDIR
    ln -sf "$DOTFILES/zsh/.zshenv" "$HOME/.zshenv"

    ln -sf "$DOTFILES/zsh/.zshrc" "$ZDOTDIR/.zshrc"
    ln -sf "$DOTFILES/zsh/.zsh" "$ZDOTDIR/.zsh"
}

function git_link(){
    mkdir -p $XDG_CONFIG_HOME/git
    ln -sf "$DOTFILES/git/.gitconfig" "$XDG_CONFIG_HOME/git/config"
    ln -sf "$DOTFILES/git/.gitignore" "$XDG_CONFIG_HOME/git/ignore"
}

function vscode_link(){
    mkdir -p $XDG_CONFIG_HOME/Code/User
    ln -sf "$DOTFILES/vscode/settings.json" "$XDG_CONFIG_HOME/Code/User/settings.json"
}

function neovim_link(){
    mkdir -p $XDG_CONFIG_HOME/nvim
    ln -sf "$DOTFILES/nvim/init.lua" "$XDG_CONFIG_HOME/nvim/init.lua"
    ln -sf "$DOTFILES/nvim/lua" "$XDG_CONFIG_HOME/nvim/lua"
}

function main(){
    zsh_link
    git_link
    vscode_link
    neovim_link
}

main