#!/usr/bin/env bash
########################################
# variables
########################################
dotfiles="$HOME/dotfiles"

remote_url="https://github.com/isksss/dotfiles.git"
ssh_url="git@github.com:isksss/dotfiles.git"

XDG_CONFIG_HOME="$HOME/.config"
XDG_CACHE_HOME="$HOME/.cache"
XDG_DATA_HOME="$HOME/.local/share"
XDG_STATE_HOME="$HOME/.local/state"
workspace="$HOME/workspace"
LOCAL_BIN="$HOME/.local/bin"

########################################
# make directory
########################################
mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME"
mkdir -p "$LOCAL_BIN" "$workspace" "$LOCAL_BIN"

########################################
# check requirements
########################################
if [ -d "$dotfiles" ]; then
    echo "dotfiles already exists"
    exit 0
fi
if ! command -v git &> /dev/null; then
    echo "git is required"
    exit 0
fi

########################################
# clone repository
########################################
git clone "$remote_url" "$dotfiles" >/dev/null 2>&1
git remote set-url origin "$ssh_url" >/dev/null 2>&1