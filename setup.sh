#!/bin/bash
#=====#=====#=====#=====#=====#=====#
# Dotfiles setup script
# Author: @isksss
#=====#=====#=====#=====#=====#=====#

#====================#
# 引数
#====================#
if [ "$1" = "-f" ]; then
    echo "Force mode"
    FORCE=true
else
    echo "Dry run"
    FORCE=false
fi

#====================#
# Variables
#====================#
# XDG Base Directory Specification
XDG_CONFIG_HOME="$HOME/.config"
XDG_CACHE_HOME="$HOME/.cache"
XDG_DATA_HOME="$HOME/.local/share"
XDG_STATE_HOME="$HOME/.local/state"

CURRENT_DIR=$(cd $(dirname $0) || exit; pwd)
WORKSPACE="$HOME/workspace"

# private scripts
SCRIPT_DIR="$HOME/.local/bin"

#====================#
# Functions
#====================#
create_link() {
  local src=$1
  local dst=$2
  if [ -e "$dst" ]; then
    if [ $FORCE = true ]; then
      rm "$dst"
      ln -sf "$src" "$dst"
      echo "Force mode: Removed $dst and created link: $dst"
        return
    else
    echo "File already exists: $dst"
    fi
  else
    ln -sf "$src" "$dst"
    echo "Created link: $dst"
  fi
}

#====================#
# Main
#====================#
# make directories
mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_CACHE_HOME"
mkdir -p "$XDG_DATA_HOME"
mkdir -p "$XDG_STATE_HOME"
mkdir -p "$WORKSPACE"

# home directory
for f in $(find $CURRENT_DIR/home -maxdepth 1 -type f); do
  create_link "$f" "$HOME"/$(basename $f)
done

# XDG_CONFIG_HOME
mkdir -p "$XDG_CONFIG_HOME"
for f in $(find $CURRENT_DIR/.config -maxdepth 1 -type d); do
    # .configのときはスキップ
    if [ $(basename $f) = ".config" ]; then
        continue
    fi
    create_link "$f" "$XDG_CONFIG_HOME"/$(basename $f)
done

# script
mkdir -p "$SCRIPT_DIR"
for f in $(find $CURRENT_DIR/script -maxdepth 1 -type f); do
    chmod +x $f
    create_link $f $SCRIPT_DIR/$(basename $f)
    chmod +x $SCRIPT_DIR/$(basename $f)
done

# symlink delete
for f in $(find $CURRENT_DIR -type l); do
    echo "Remove link: $f"
    rm $f
done
