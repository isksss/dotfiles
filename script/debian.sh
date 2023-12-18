#!/bin/sh

sudo apt update
sudo apt install -y \
    git \
    curl \
    zsh \
    gcc \
    cmake \
    make \
    build-essential \


cargo install \
    starship \
    bat \
    