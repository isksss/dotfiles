#!/usr/bin/env bash

## var
DOTFILES_DIR="$HOME/dotfiles"
WORKSPACE_DIR="$HOME/workspace"
REMOTE_URL="https://github.com/isksss/dotfiles.git"
SSH_URL="git@github.com:isksss/dotfiles.git"
XDG_CONFIG_HOME="$HOME/.config"
XDG_CACHE_HOME="$HOME/.cache"
XDG_DATA_HOME="$HOME/.local/share"
XDG_STATE_HOME="$HOME/.local/state"

CURRENT_DIR=$(pwd)

### color
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"

RESET="\e[0m"

## func
# echo info message
function info() {
    echo -e "${GREEN}[INFO]${RESET} $1"
}
# echo error message
function error() {
    echo -e "${RED}[ERROR]${RESET} $1"
}
# echo warning message
function warning() {
    echo -e "${YELLOW}[WARNING]${RESET} $1"
}
# echo debug message
function debug() {
    echo -e "${BLUE}[WARNING]${BLUE} $1"
}
# check if command exists
function command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# check if git is installed
if ! command_exists "git"; then
    error "git is not installed"
    exit 1
fi

## install
if ! [ -d "$DOTFILES_DIR" ]; then
    warning "dotfiles already exists"
    # download dotfiles
    info "Downloading dotfiles..."
    git clone "$REMOTE_URL" "$DOTFILES_DIR" >/dev/null 2>&1
    # change remote url to ssh
    cd "$DOTFILES_DIR"
    info "Changing remote url to ssh..."
    git remote set-url origin "$SSH_URL"
fi

# make dir
mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_CACHE_HOME"
mkdir -p "$XDG_DATA_HOME"
mkdir -p "$XDG_STATE_HOME"
mkdir -p "$WORKSPACE_DIR"
