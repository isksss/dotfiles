#!/usr/bin/env bash

#--------------------------------------------------
# variables
#--------------------------------------------------
export DOTFILES="$HOME/dotfiles"
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache

DOT_URL="https://github.com/isksss/dotfiles.git"
DOT_SSH="git@github.com:isksss/dotfiles.git"
RELEASE_FILE="/etc/os-release"

OS="OS"
#--------------------------------------------------
# utils
#--------------------------------------------------
info(){
    echo -e "\033[32m$*\033[00m"
}

error(){
    echo -e "\033[31m$*\033[00m"
}

warn() {
    echo -e "\033[33m$*\033[00m"
}

devnull="> /dev/null"

AppExists(){
    local app_name="$1"
    if command -v "$app_name" > /dev/null 2>&1; then
        return 1
    else
        return 0
    fi
}
#--------------------------------------------------
# functions
#--------------------------------------------------
checkOS(){
    if [ "$(uname)" == 'Darwin' ]; then
        OS='Darwin'
    elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
        if grep '^NAME="Arch' "$RELEASE_FILE" > /dev/null; then
            OS=Arch
        elif grep '^NAME="Ubuntu' "$RELEASE_FILE" > /dev/null; then
            OS=Ubuntu
        fi
    fi
}

setUp(){
    case $OS in
        Darwin) Darwin;;
        Arch) Arch;;
        Manjaro) Manjaro;;
        Ubuntu) Ubuntu;;
        *) echo "$OS is not supported.";;
    esac
}

cloneRepo(){
    if [ -d "$HOME/dotfiles" ]; then
        error "Dotfiles Repository is exists."
    else
        warn "Dotfiles Repository is not exists."
        #todo: リポジトリを持ってくる操作
        git clone $DOT_URL $HOME/dotfiles > /dev/null
        cd $DOTFILES
        git remote set-url origin $DOT_SSH > /dev/null
    fi
}

# Arch
Arch(){
    info "Arch Install"
    sudo pacman -Syy > /dev/null
    pacInstall git zsh neovim

    if AppExists "yay" ; then
        warn "Yay is not exists."
        yayDownload
    fi
    yay -Syy
    # yayInstall
}

pacInstall(){
    for app in "$@"
    do
        if ! pacman -Qs "$app" > /dev/null;then
            info ">>> Install $app"
            sudo pacman --noconfirm -S "$@" > /dev/null
        else
            warn ">>> Installed $app"
        fi
    done
}

yayDownload(){
    pacInstall base-devel
    git clone --depth 1 https://aur.archlinux.org/yay.git ~/yay > /dev/null
    CURRENT_DIR="$(pwd)"
    cd ~/yay
    makepkg -si > /dev/null
    cd $CURRENT_DIR
    rm -rf "~/yay"
}

yayInstall(){
    for app in "$@"
    do
        if ! yay -Qs "$app" > /dev/null;then
            info ">>> Install $app"
            yay --noconfirm -S "$@" > /dev/null
        else
            warn ">>> Installed $app"
        fi
    done
}

nvimSetup(){
    NVIM_HOME=$XDG_CONFIG_HOME/nvim
    rm -rf $NVIM_HOME

    if [ ! -d "$NVIM_HOME" ]; then
        mkdir -p "$NVIM_HOME" &>/dev/null
    fi

    # Clone required repositories
    packer_dir="$HOME/.local/share/nvim/site/pack/packer/opt/packer.nvim"
    if [ ! -d $packer_dir ]; then
        git clone --depth 1 https://github.com/wbthomason/packer.nvim $packer_dir > /dev/null
    fi

    ln -sf $DOTFILES/nvim/init.lua $NVIM_HOME/init.lua
    ln -sf $DOTFILES/nvim/lua $NVIM_HOME/lua
}

#--------------------------------------------------
# main
#--------------------------------------------------
main(){
    # OS判別
    checkOS
    # インストーラー
    setUp

    # Download dotfiles
    cloneRepo

    # zsh
    ZSH_BIN=$(which zsh)
    if [ "$SHELL" != "$ZSH_BIN" ];then
        warn "Change Shell: $SHELL to $ZSH_BIN"
        echo "$ZSH_BIN" >> /etc/shells
        chsh -s "$ZSH_BIN"
    fi

    # git
    ln -sf "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
    ln -sf "$DOTFILES/git/.gitignore_global" "$HOME/.gitignore_global"

    # nvim
    nvimSetup
}

main