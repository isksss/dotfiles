#!/bin/bash
# MacとLinux用のインストールスクリプト

########################################
# variables
########################################
dotfiles=`pwd`
XDG_CONFIG_HOME="${HOME}/.config"
XDG_CACHE_HOME="${HOME}/.cache"
XDG_DATA_HOME="${HOME}/.local/share"
XDG_STATE_HOME="${HOME}/.local/state"

########################################
# check requirements
########################################
required_commands=(
    "bash"
)

for command in "${required_commands[@]}"; do
    if ! type "$command" > /dev/null 2>&1; then
        echo "$command is required"
        exit 1
    fi
done

########################################
# functions
########################################
# RED
function echo_error() {
    echo -e "\e[31m$1\e[m"
}
# GREEN
function echo_success() {
    echo -e "\e[32m$1\e[m"
}
# YELLOW
function echo_warning() {
    echo -e "\e[33m$1\e[m"
}

# OSごとにインストールコマンドを変える
install_commands() {
    local os_type=$(uname -s)
    local command=("$1")
    echo_success "[installing] $1"
    error_msg(){
        echo_error "[error] Unknown Distribution."
        echo_error "        Please install manually $command."
    }

    case "$os_type" in
        Linux*)
            if [ -e /etc/arch-release ]; then
                sudo pacman -S --noconfirm $command
            elif [ -e /etc/lsb-release ]; then
                sudo apt install -y $command
            else
                error_msg
            fi
            ;;
        Darwin*)
            brew install $command
            ;;
        *)        
            error_msg;;
  esac
}

make_dir(){
    mkdir -p $XDG_CONFIG_HOME
    mkdir -p $XDG_CACHE_HOME
    mkdir -p $XDG_DATA_HOME
    mkdir -p $XDG_STATE_HOME

    mkdir -p "${HOME}/.local/bin"
    mkdir -p "${HOME}/.local/src"
}
########################################
# main
########################################
main(){
    echo "== DOTFILES SETUP =="
    echo "This script is for Mac and Linux."
    echo "== DOTFILES SETUP =="
    echo ${dotfiles} > ${HOME}/.dotfiles-path
    make_dir

    commands=(
        "git"
        "zsh"
    )

    for command in "${commands[@]}"; do
        if ! type "$command" > /dev/null 2>&1; then
            install_commands "$command"
        fi
    done

    chmod +X ./.installscript/*
    bash ./.installscript/link.sh
}

main