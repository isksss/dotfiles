#!/usr/bin/env zsh

# variables
dotfiles="$HOME/dotfiles"

remote_url="https://github.com/isksss/dotfiles.git"
ssh_url="git@github.com:isksss/dotfiles.git"

XDG_CONFIG_HOME="$HOME/.config"
XDG_CACHE_HOME="$HOME/.cache"
XDG_DATA_HOME="$HOME/.local/share"
XDG_STATE_HOME="$HOME/.local/state"

LOCAL_BIN="$HOME/.local/bin"

# functions
function install() {
    if [ -d "$dotfiles" ]; then
        echo "dotfiles already exists"
        exit 0
    fi

    # git is required
    if ! command -v git &> /dev/null; then
        echo "git is required"
        exit 0
    fi

    # clone dotfiles
    git clone "$remote_url" "$dotfiles" >/dev/null 2>&1
    git remote set-url origin "$ssh_url" >/dev/null 2>&1

    cd "$dotfiles" || exit 0
    make install >/dev/null 2>&1
}

function dir() {
    mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME"
    mkdir -p "$LOCAL_BIN"
}

function main(){
    dir
    install
}

main
