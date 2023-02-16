#!/bin/sh

OS=$(uname)

echo "OS:$OS"
if [ $OS = "Linux" ];then
    $DOTFILES/installer/linux/_install.sh
fi