#!/bin/bash

#----- ----- ----- ----- -----
XDG_CONFIG_HOME="$HOME/.config"

SCRIPT_DIR=$(cd $(dirname $0); pwd)
CONFIG_DIR=$SCRIPT_DIR/.config

#----- ----- ----- ----- -----
mkdir -p $XDG_CONFIG_HOME

#----- ----- ----- ----- -----
# シンボリックリンクを削除する関数
remove_symlink() {
    local target_path="$1"
    if [ -L "$target_path" ]; then
        rm "$target_path"
    elif [ -d "$target_path" ]; then
        rm -r "$target_path"
    fi
}

# シンボリックリンクを作成する関数
create_symlink() {
    local target_path="$1"
    local link_path="$2"
    remove_symlink "$target_path"
    ln -sf "$link_path" "$target_path"
}

#----- ----- ----- ----- -----
# zsh
create_symlink "$HOME/.zshenv" "$SCRIPT_DIR/.zshenv"
create_symlink "$XDG_CONFIG_HOME/zsh" "$CONFIG_DIR/zsh"

# wezterm
create_symlink "$XDG_CONFIG_HOME/wezterm" "$CONFIG_DIR/wezterm"

# vim
create_symlink "$HOME/.vimrc" "$SCRIPT_DIR/.vimrc"

# nvim
create_symlink "$XDG_CONFIG_HOME/nvim" "$CONFIG_DIR/nvim"

# x
create_symlink "$HOME/.xprofile" "$SCRIPT_DIR/.xprofile"

# git
create_symlink "$HOME/.gitignore" "$SCRIPT_DIR/.gitignore"
create_symlink "$XDG_CONFIG_HOME/git" "$CONFIG_DIR/git"

#----- ----- ----- ----- -----
