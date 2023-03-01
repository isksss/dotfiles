#!/bin/sh
sudo apt update

#########
# utils #
#########

## git
git --version
if [ $? -gt 0 ]; then
    sudo apt install -y git
fi

## wget
wget --version >> /dev/null
if [ $? -gt 0 ]; then
    sudo apt install -y wget
fi

## etc
# sudo apt install -y tree curl nvim zsh
# sudo apt upgrade -y

#######
# zsh #
#######
which zsh >> /dev/null
if [ $? -gt 0 ]; then
    sudo apt install -y zsh
fi

if [ $SHELL != $(which zsh) ];then
    chsh -s $(which zsh)
fi

########
# code #
########
code --version >> /dev/null
if [ $? -gt 0 ]; then
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt update
    sudo apt install -y code 
fi

