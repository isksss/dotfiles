#!/bin/sh

sudo apt update
sudo apt install -y \
    git \
    curl \
    zsh \
    gcc

cargo install \
    starship \
    