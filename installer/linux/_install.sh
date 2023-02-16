#!/bin/sh
sudo apt update

## git
git --version
if [ $? -gt 0 ]; then
    sudo apt install -y git
fi

## etc
sudo apt install -y tree curl nvim zsh
sudo apt upgrade -y