#!/bin/sh
set -e

if [ "$(uname)" != "Linux" ];then
    exit 1
fi

if [ ! $(which pacman) ]; then
    exit 1
fi

for app in `cat $DOTFILES/_script/arch/app-list.txt`
do
    if [[ "${app}" = "#"* ]];then
        continue
    fi
    if !(which ${app} > /dev/null 2>&1); then
        pacman --noconfirm -S ${app} > /dev/null 2>&1
    fi
done