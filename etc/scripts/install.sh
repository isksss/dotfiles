#!/usr/bin/env bash

#--------------------------------------------------
# variables
#--------------------------------------------------
export DOTFILES="$HOME/dotfiles"
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache

DOT_URL="https://github.com/isksss/dotfiles.git"
DOT_SSH="git@github.com:isksss/dotfiles.git"
RELEASE_FILE="/etc/os-release"

OS="OS"
#--------------------------------------------------
# utils
#--------------------------------------------------
info(){
    echo -e "\033[32m$*\033[00m"
}

error(){
    echo -e "\033[31m$*\033[00m"
}

warn() {
    echo -e "\033[33m$*\033[00m"
}

devnull="> /dev/null"
#--------------------------------------------------
# functions
#--------------------------------------------------
checkOS(){
    if [ "$(uname)" == 'Darwin' ]; then
        OS='Darwin'
    elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
        if grep '^NAME="Arch' "$RELEASE_FILE" > /dev/null; then
            OS=Arch
        elif grep '^NAME="Ubuntu' "$RELEASE_FILE" > /dev/null; then
            OS=Ubuntu
        fi
    fi
}

setUp(){
    case $OS in
        Darwin) Darwin;;
        Arch) Arch;;
        Manjaro) Manjaro;;
        Ubuntu) Ubuntu;;
        *) echo "$OS is not supported.";;
    esac
}

cloneRepo(){
    if [ -d "$HOME/dotfiles" ]; then
        error "Dotfiles Repository is exists."
    else
        warn "Dotfiles Repository is not exists."
        #todo: リポジトリを持ってくる操作
        git clone $DOT_URL $HOME/dotfiles > /dev/null
        cd $DOTFILES
        git remote set-url origin $DOT_SSH > /dev/null
    fi
}

# Arch
Arch(){
    info "Arch Install"
    sudo pacman -Syy > /dev/null
    pacInstall git zsh
}

pacInstall(){
    for app in "$@"
    do
        if ! pacman -Qs "$app" > /dev/null;then
            info ">>> Install $app"
            sudo pacman --noconfirm -S "$@" > /dev/null
        else
            warn ">>> Installed $app"
        fi
    done
}

#--------------------------------------------------
# main
#--------------------------------------------------
main(){
    # OS判別
    checkOS
    # インストーラー
    setUp

    # Download dotfiles
    cloneRepo
}

main