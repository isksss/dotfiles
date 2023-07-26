#!/bin/bash
# MacとLinux用のインストールスクリプト

########################################
# variables
########################################
dotfiles="$HOME/dotfiles"

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

########################################
# main
########################################
main(){
    commands=(
        "git"
        "zsh"
        "starship"
    )

    for command in "${commands[@]}"; do
        if ! type "$command" > /dev/null 2>&1; then
            install_commands "$command"
        fi
    done

    # Rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

main