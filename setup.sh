#!/usr/bin/env bash

# Setup dotfiles

## Variables
DOTFILES_DIR="$HOME/dotfiles"

REMOTE_URL="https://github.com/isksss/dotfiles.git"
SSH_URL="git@github.com:isksss/dotfiles.git"

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"

RESET="\e[0m"
## Functions
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

# check if command exists
function command_exists() {
    command -v "$1" >/dev/null 2>&1
}

### Download dotfiles
function download_dotfiles() {
    if [ -d "$HOME/dotfiles" ]; then
        warning "dotfiles already exists"
        exit 1
    fi
    
    # check if git is installed
    if ! command_exists "git"; then
        error "git is not installed"
        exit 1
    fi

    # download dotfiles
    info "Downloading dotfiles..."
    git clone "$REMOTE_URL" "$DOTFILES_DIR"

    # check if dotfiles is downloaded
    if [ ! -d "$DOTFILES_DIR" ]; then
        error "dotfiles is not downloaded"
        exit 1
    fi

    # change directory to dotfiles
    info "Changing directory to dotfiles..."
    local CURRENT_DIR=$(pwd)
    cd "$DOTFILES_DIR"

    # change remote url to ssh
    info "Changing remote url to ssh..."
    git remote set-url origin "$SSH_URL"
}

function main() {
    download_dotfiles
}

main