#!/bin/sh
sudo apt update > /dev/null

#########
# utils #
#########

## git
git --version
if [ $? -gt 0 ]; then
    sudo apt install -y git > /dev/null
fi

## wget
wget --version >> /dev/null
if [ $? -gt 0 ]; then
    sudo apt install -y wget > /dev/null
fi

## xclip
which xclip >> /dev/null
if [ $? -gt 0 ]; then
    sudo apt install -y clip > /dev/null
fi

## etc
# sudo apt install -y tree curl nvim zsh
# sudo apt upgrade -y

#######
# zsh #
#######
which zsh >> /dev/null
if [ $? -gt 0 ]; then
    sudo apt install -y zsh > /dev/null
fi

if [ $SHELL != $(which zsh) ];then
    chsh -s $(which zsh)
fi

########
# code #
########
code --version >> /dev/null
if [ $? -gt 0 ]; then
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add - > /dev/null
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /dev/null
    sudo apt update > /dev/null
    sudo apt install -y code > /dev/null
fi

