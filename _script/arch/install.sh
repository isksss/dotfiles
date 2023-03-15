#!/bin/sh
# set -e

if [ "$(uname)" != "Linux" ];then
    exit 1
fi

if [ ! $(which pacman) ]; then
    exit 1
fi

echo "#####################"
echo "### pacman update ###"
echo "#####################"
pacman --noconfirm -Syu

echo "###################"
echo "### app install ###"
echo "###################"
for app in `cat $DOTFILES/_script/arch/app-list.txt`
do
    if [[ "${app}" =~ [\#]+ ]];then
        continue
    fi
    
    if !(which ${app} > /dev/null 2>&1); then
        echo ">>> ${app} is not installed. so, now install..."
        pacman --noconfirm -S ${app} > /dev/null 2>&1
    fi
done

# docker
# if [ $(which docker) ]; then
#     systemctl enable docker
#     systemctl restart docker
# fi
if !(getent group docker > /dev/null 2>&1); then
    groupadd docker
fi

if !(getent group docker | grep "$(whoami)" > /dev/null 2>&1);then
    sudo usermod -aG docker "$(whoami)"
fi

# perl, locale
cat /etc/locale.gen| sed "s/\#ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/g" > /dev/null 2>&1