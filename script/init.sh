#!/usr/bin/env zsh

# Setup dotfiles
## Variables
DOTFILES="$HOME/dotfiles"

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

# check if file exists
function file_exists() {
    [[ -f "$1" ]]
}

# check if directory exists
function directory_exists() {
    [[ -d "$1" ]]
}

# check if symlink exists
function symlink_exists() {
    [[ -L "$1" ]]
}

# os detection
function os() {
    local os
    os=$(uname -s)
    case "${os}" in
        Linux*)     
                info "linux"
                if is_arch; then
                    info "arch"
                elif is_ubuntu; then
                    info "ubuntu"
                elif is_manjaro; then
                    info "manjaro"
                else
                    error "This script is only for Arch Linux, Ubuntu and Manjaro"
                    exit 1
                fi
                ;;
        Darwin*)    info "mac";;
        CYGWIN*)    info "cygwin";;
        MINGW*)     info "mingw";;
        *)          echo "unknown";;
    esac
}

# check if os is arch
function is_arch() {
    local os=$(cat /etc/os-release | grep -E "^ID=" | cut -d "=" -f 2)
    [[ "$(os)" == "arch" ]]
}

# check if os is ubuntu
function is_ubuntu() {
    local os=$(cat /etc/os-release | grep -E "^ID=" | cut -d "=" -f 2)
    [[ "$(os)" == "ubuntu" ]]
}

# check if os is manjaro
function is_manjaro() {
    local os=$(cat /etc/os-release | grep -E "^ID=" | cut -d "=" -f 2)
    [[ "$(os)" == "manjaro" ]]
}

# symlink
function symlink() {
    local source=$1
    local target=$2

    if symlink_exists "$target"; then
        warning "$target is already symlinked"
        return 1
    fi

    if file_exists "$target"; then
        warning "$target is already exists"
        return 1
    fi

    if directory_exists "$target"; then
        warning "$target is already exists"
        return 1
    fi

    ln -s "$source" "$target"
    info "Symlinked $source to $target"
}


## arch linux and manjaro
# check if package is installed
function pacman_install() {
    local package=$1
    if ! pacman -Q "$package" >/dev/null 2>&1; then
        sudo pacman --noconfirm --needed -S "$package" >/dev/null 2>&1
    fi
}

# check if aur package is installed
function aur_install() {
    local package=$1
    if ! pacman -Q "$package" >/dev/null 2>&1; then
        yay --noconfirm --needed -S "$package" >/dev/null 2>&1
    fi
}

# installed yay
function yay_install() {

    ## check if yay is installed
    if ! command_exists "yay"; then
        # check if os is arch
        if is_arch; then
            # install yay
            info "Installing yay..."
            git clone https://aur.archlinux.org/yay.git /tmp/yay >/dev/null 2>&1
            cd /tmp/yay
            makepkg -si --noconfirm >/dev/null 2>&1
            cd -
            rm -rf /tmp/yay
            return
        fi

        # check if os is manjaro
        if is_manjaro; then
            # install yay
            info "Installing yay..."
            sudo pacman --noconfirm --needed -S yay >/dev/null 2>&1
            return
        fi
    else
        info "yay is already installed"
    fi
}

## ubuntu
# check if package is installed
function apt_install() {
    local package=$1
    if ! dpkg -s "$package" >/dev/null 2>&1; then
        sudo apt install -y "$package" >/dev/null 2>&1
    fi
}




