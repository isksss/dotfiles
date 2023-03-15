#!/bin/sh
# set -e

if [ "$(uname)" != "Linux" ];then
    exit 1
fi

if [ ! $(which pacman) ]; then
    exit 1
fi
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

printf "#####################\n"
printf "#   ${YELLOW}pacman update${NC}   #\n"
printf "#####################\n"
pacman --noconfirm -Syu

printf "###################\n"
printf "#   ${YELLOW}app install${NC}   #\n"
printf "###################\n"

for app in `cat $DOTFILES/_script/arch/app-list.txt`
do
    if [[ "${app}" =~ [\#]+ ]];then
        continue
    fi

    if (pacman -Qi ${app} > /dev/null 2>&1); then
        printf ">>> ${GREEN}INSTALLED${NC}: ${app}\n"
    else
        printf ">>> ${RED}NOT INSTALLED${NC}: ${app}\n"
        printf ">>> ${YELLOW}INSTALL START${NC}: ${app}...\n"
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