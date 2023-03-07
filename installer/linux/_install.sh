#!/bin/sh
sudo apt update > /dev/null

#########
# utils #
#########
APP_LIST="git wget xclip tree neovim zsh"

for APP in $APP_LIST
do
    which $APP
    if [ $? -gt 0 ]; then
        sudo apt install -y $APP > /dev/null
    fi
done

#######
# zsh #
#######
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

