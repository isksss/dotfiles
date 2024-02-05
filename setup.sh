#!/bin/bash
#=====#=====#=====#=====#=====#=====#
# Dotfiles setup script
# Author: @isksss
#=====#=====#=====#=====#=====#=====#

#====================#
# Variables
#====================#
# XDG Base Directory Specification
XDG_CONFIG_HOME="$HOME/.config"
XDG_CACHE_HOME="$HOME/.cache"
XDG_DATA_HOME="$HOME/.local/share"
XDG_STATE_HOME="$HOME/.local/state"

CURRENT_DIR=$(cd $(dirname $0); pwd)
WORKSPACE="$HOME/workspace"

#====================#
# Functions
#====================#
create_link() {
  local src=$1
  local dst=$2
  if [ -e $dst ]; then
    echo "File already exists: $dst"
  else
    ln -sf $src $dst
    echo "Created link: $dst"
  fi
}

#====================#
# Main
#====================#
# make directories
mkdir -p $XDG_CONFIG_HOME
mkdir -p $XDG_CACHE_HOME
mkdir -p $XDG_DATA_HOME
mkdir -p $XDG_STATE_HOME
mkdir -p $WORKSPACE

# home directory
for f in `find $CURRENT_DIR/home -maxdepth 1 -type f`; do
  create_link $f $HOME/$(basename $f)
done

# XDG_CONFIG_HOME
mkdir -p $XDG_CONFIG_HOME
for f in `find $CURRENT_DIR/.config -maxdepth 1 -type d`; do
    # .configのときはスキップ
    if [ $(basename $f) = ".config" ]; then
        continue
    fi
    create_link $f $XDG_CONFIG_HOME/$(basename $f)
done