#!/usr/bin/env bash
clear && cat <<EOF
#--------------------------------------------------
# My Dotfiles Script.
#--------------------------------------------------
EOF

#--------------------------------------------------
# usage
#--------------------------------------------------
usage(){
    cat 1>&2 <<EOF
#--------------------------------------------------
Usage: $(basename $0) [OPTION]

Options:
    -h        help
#--------------------------------------------------
EOF
    exit 0
}

#--------------------------------------------------
# variables
#--------------------------------------------------
export DOTFILES="$HOME/dotfiles"
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
OS=""
DOT_URL="https://github.com/isksss/dotfiles.git"
DOT_SSH="git@github.com:isksss/dotfiles.git"

#--------------------------------------------------
# functions
#--------------------------------------------------

#------------------------------
# OS
#------------------------------

# Common
CommonOS(){
    chmod -R +x $DOTFILES/bin/*
    Chsh
    NvimSetting
    SymLink
    Installer

    if [ ! -d "$HOME/workspace" ]; then
        mkdir -p $HOME/workspace
    fi
}
# Mac Setup Script
Darwin(){
    echo "Darwin Setup."

    CommonOS
}

# Arch Setup Script
Arch(){
    echo "Arch Setup."
    PacInstall zsh git xclip neovim go
    
    if ! command -v yay;then
        YayInstaller
    fi

    sudo pacman -Scc
    CommonOS
}

# manjaro
Manjaro(){
    PacInstall yay vivaldi
    YayInstall volta-bin google-chrome visual-studio-code-bin
    Arch
}

# ubuntu
Ubuntu(){
    #todo: 
}

#------------------------------
# Utils
#------------------------------

# get dotfiles repository.
getRepo(){
    if [ -d "$HOME/dotfiles" ]; then
        echo "Dotfiles Repository is exists."
    else
        echo "Dotfiles Repository is not exists."
        #todo: リポジトリを持ってくる操作
        git clone $DOT_URL $HOME/dotfiles
        cd $DOTFILES
        git remote set-url origin $DOT_SSH
    fi
}

makeSshKey(){
    if [ ! -d "$HOME/.ssh" ];then
        mkdir -p "$HOME/.ssh"
    fi
    #todo: make ssh-key
    CURRENT_DIR=$(pwd)
    cd ~/.ssh
    ssh-keygen -b 4096
    cd $CURRENT_DIR
}

PacInstall(){
    sudo pacman -Syy > /dev/null
    for app in "$@"
    do
        if ! pacman -Qs "$app" > /dev/null;then
            echo ">>> Install $app"
            sudo pacman --noconfirm -S "$@" > /dev/null
        fi
    done
}

YayInstall(){
    yay -Syy > /dev/null
    for app in "$@"
    do
        if ! yay -Qs "$app" > /dev/null;then
            echo ">>> Install $app"
            yay --noconfirm -S "$@" > /dev/null
        fi
    done
}

Chsh(){
    ZSH_BIN=$(which zsh)
    if [ "$SHELL" != "$ZSH_BIN" ];then
        echo "Change Shell: $SHELL to $ZSH_BIN"
        chsh -s "$ZSH_BIN"
    fi 
}

SymLink(){
    # zsh
    if command -v zsh ;then
        ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
        ln -sf "$DOTFILES/zsh/.zshenv" "$HOME/.zshenv"
        ln -sf "$DOTFILES/zsh/.zsh/" "$HOME/.zsh"
    fi

    if [ -d /$DOTFILES/zsh/.zsh/.zsh ]; then
        rm -rf "$DOTFILES/zsh/.zsh/.zsh"
    fi

    # git 
    ln -sf "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
    ln -sf "$DOTFILES/git/.gitignore_global" "$HOME/.gitignore_global"
}

NvimSetting(){
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
}

DockerGroup(){
    if ! (getent group docker > /dev/null 2>&1); then
        groupadd docker
    fi

    if ! (getent group docker | grep "$(whoami)" > /dev/null 2>&1);then
        sudo usermod -aG docker "$(whoami)"
    fi
}

YayInstaller(){
    PacInstall base-devel
    git clone --depth 1 https://aur.archlinux.org/yay.git ~/yay
    CURRENT_DIR="$(pwd)"
    cd ~/yay
    makepkg -si
    cd $CURRENT_DIR
    rm -rf "~/yay"
}

AppExists(){
    local app_name="$1"
    if command -v "$app_name" > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

Installer(){
    # volta
    if ! AppExists "volta"; then
        curl https://get.volta.sh | bash
    fi
}

#--------------------------------------------------
# option
#--------------------------------------------------
while getopts ':o:h' opt; do
    case "${opt}" in
        h) usage;;
        ?) usage;;
    esac
done

#--------------------------------------------------
# main
#--------------------------------------------------
main(){

    # Input OS
    read -p "Input your OS > " OS
    if [ -z "$OS" ];then
            echo "Please input your OS."
            exit 1
    fi

    # get git repo
    getRepo
    
    case $OS in
        Darwin) Darwin;;
        Arch) Arch;;
        Manjaro) Manjaro;;
        Ubuntu) Ubuntu;;
        *) echo "$OS is not supported.";;
    esac
}

main
