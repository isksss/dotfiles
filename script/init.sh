#!/usr/bin/env zsh

# Setup dotfiles
## Variables
DOTFILES="$HOME/dotfiles"

XDG_CONFIG_HOME="$HOME/.config"
XDG_CACHE_HOME="$HOME/.cache"
XDG_DATA_HOME="$HOME/.local/share"
XDG_STATE_HOME="$HOME/.local/state"

# colors
autoload -U colors; colors

## Functions
# echo info message
function info() {
    echo -e "${fg[green]}[INFO]${reset_color} $1"
}

function info_no() {
    echo -en "${fg[green]}[INFO]${reset_color} $1"
}

# echo error message
function error() {
    echo -e "${fg[red]}[ERROR]${reset_color} $1"
}

function error_no() {
    echo -en "${fg[red]}[ERROR]${reset_color} $1"
}

# echo warning message
function warning() {
    echo -e "${fg[yellow]}[WARNING]${reset_color} $1"
}
function warning_no() {
    echo -en "${fg[yellow]}[WARNING]${reset_color} $1"
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
        if ! link_delete $target; then
            error "Failed to delete $target\n"
            return 1
        fi
    fi

    if file_exists "$target"; then
        warning "$target is already exists"
        if ! link_delete $target; then
            error "Failed to delete $target\n"
            return 1
        fi
    fi

    if directory_exists "$target"; then
        warning "$target is already exists"
        if ! link_delete $target; then
            error "Failed to delete $target\n"
            return 1
        fi
    fi

    ln -s "$source" "$target"
    info "Symlinked $source to $target\n"
}


## arch linux and manjaro
# check if package is installed

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

        warning "Yay is not installed"
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

# symlink dotfiles
function xdg_link(){
    # xdg dir variables
    local xdg_config_home=$XDG_CONFIG_HOME

    # xdg dirs
    local xdg_dirs=(
        "nvim"
        "tmux"
        "zsh"
        "git"
    )

    # symlink xdg dirs
    for dir in "${xdg_dirs[@]}"; do
        symlink "$DOTFILES/xdg/$dir" "$xdg_config_home/$dir"
    done
}

# home dirs link
function home_link(){
    # home dirs
    local home_dirs=(
        ".bashrc"
        ".zshenv"
        ".xprofile"
    )

    # symlink home dirs
    for dir in "${home_dirs[@]}"; do
        symlink "$DOTFILES/home/$dir" "$HOME/$dir"
    done
}

# link delete
# input: $1: link path
# you input [Y/n] to delete link
function link_delete(){
    local link=$1
    local input=""
    warning_no "REPLY?Delete $link? [Y/n] "
    read $input
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        rm -rf "$link"
        info "Deleted $link"
        return 0
    fi

    return 1
}

# main
function main(){
    # check if zsh is installed
    if ! command_exists "zsh"; then
        error "zsh is not installed"
        exit 1
    fi
    # home link
    home_link
    # xdg link
    xdg_link

    # workspace
    mkdir -p $HOME/workspace
}

main