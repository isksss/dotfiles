#!/usr/bin/env zsh
# Path: script/vim9-apt-ppa.sh

## add ppa for vim9
sudo add-apt-repository ppa:jonathonf/vim
sudo apt update

# if exists vim9
if command -v vim &> /dev/null; then
    sudo apt remove vim
fi

# install vim9
sudo apt install vim