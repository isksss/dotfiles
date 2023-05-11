#!/usr/bin/env bash
########################################
# variables
########################################
dotfiles="$HOME/dotfiles"

remote_url="https://github.com/isksss/dotfiles.git"
ssh_url="git@github.com:isksss/dotfiles.git"

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