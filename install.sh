#!/bin/sh
clear && cat <<EOF
#--------------------------------------------------
# My Dotfiles Script."
#--------------------------------------------------
EOF

#--------------------------------------------------
# usage
#--------------------------------------------------
function usage(){
    cat 1>&2 <<EOF
#--------------------------------------------------
Usage: $(basename $0) [OPTION]

Options:
    -h        help
#--------------------------------------------------
EOF
    exit -1
}
#--------------------------------------------------
# variables
#--------------------------------------------------
OS=""

#--------------------------------------------------
# functions
#--------------------------------------------------

#------------------------------
# OS
#------------------------------
# Mac Setup Script
function Darwin(){
    echo "Darwin Setup."
}

# Arch Setup Script
function Arch(){
    echo "Arch Setup."
    
    PacInstall zsh git xclip neovim
    Chsh
}

#------------------------------
# Utils
#------------------------------

# get dotfiles repository.
function getRepo(){
    if [ -d "$HOME/dotfiles" ]; then
        echo "Dotfiles Repository is exists."
    else
        echo "Dotfiles Repository is not exists."
        #todo: リポジトリを持ってくる操作
    fi
}

function makeSshKey(){
    if [ ! -d "$HOME/.ssh" ];then
        mkdir -p $HOME/.ssh
    fi
    #todo: make ssh-key
    CURRENT_DIR=$(pwd)
    cd ~/.ssh
    ssh-keygen -b 4096
}

function PacInstall(){
    sudo pacman -Syy > /dev/null
    for app in "$@"
    do
        if ! pacman -Qs $app > /dev/null;then
            echo ">>> Install $app"
            sudo pacman --noconfirm -S $@ > /dev/null
        fi
    done
}

function Chsh(){
    ZSH_BIN=$(which zsh)
    if [ "$SHELL" != "$ZSH_BIN" ];then
        echo "Change Shell: $SHELL to $ZSH_BIN"
        chsh -s $ZSH_BIN
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
function main(){

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
        *) echo "$OS is not supported.";;
    esac
}

main
