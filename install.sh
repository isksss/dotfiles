#!/usr/bin/env zsh

# variables
dotfiles="$HOME/.dotfiles"

remote_url="https://github.com/isksss/dotfiles.git"
ssh_url="git@github.com:isksss/dotfiles.git"

XDG_CONFIG_HOME="$HOME/.config"
XDG_CACHE_HOME="$HOME/.cache"
XDG_DATA_HOME="$HOME/.local/share"
XDG_STATE_HOME="$HOME/.local/state"

# functions
function install() {
    if [ -d "$dotfiles" ]; then
        echo "dotfiles already exists"
        exit 1
    fi

    # git is required
    if ! command -v git &> /dev/null; then
        echo "git is required"
        exit 1
    fi

    # clone dotfiles
    git clone --recursive "$remote_url" "$dotfiles" >/dev/null 2>&1
    git remote set-url origin "$ssh_url" >/dev/null 2>&1

    cd "$dotfiles" || exit 1
    make install >/dev/null 2>&1
}

function dir() {
    mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME"
}

function main(){
    dir
    install
}

main
