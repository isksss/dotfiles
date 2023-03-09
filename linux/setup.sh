#!/bin/sh
#----- ----- ----- ----- -----
# Setup Shell Script
#----- ----- ----- ----- -----

##############################
# for Ubuntu
## install
### APP LIST
# git, curl, wget, tree, zsh
# golang, python
for APP in $APP_LIST
do
    which $APP
    if [ $? -gt 0 ]; then
        sudo apt install -y $APP > /dev/null
    fi
done


##############################
# for Mac
## install

##############################
# for ALL OS
## symbolic link
## other setup

