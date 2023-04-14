#!/usr/bin/env zsh

## pacman
pacapp=(
    "git"
    "go"
    "neovim"
    "zsh"
    "exa"
    "bat"
    "tmux"
    "fcitx5-mozc"
    "fcitx5-im"
    "ttf-noto-nerd"
)

## yay
yayapp=(
    "google-chrome"
    "visual-studio-code-bin"
)

function pacman_install() {
    local package=$1
    if ! pacman -Q "$package" >/dev/null 2>&1; then
        echo -e "${fg[yellow]}[warning]${reset_color}$app"
        sudo pacman --noconfirm --needed -S "$package" >/dev/null 2>&1
    fi
}

# check if aur package is installed
function aur_install() {
    local package=$1
    if ! pacman -Q "$package" >/dev/null 2>&1; then
        echo -e "${fg[yellow]}[warning]${reset_color}$app"
        yay --noconfirm --needed -S "$package" >/dev/null 2>&1
    fi
}

function main(){
    autoload -U colors; colors
    for app in "${pacapp[@]}"; do
        echo -e "${fg[green]}[info]${reset_color}$app"
        pacman_install $app
    done
    echo "===== ===== ===== ===== ====="
    for app in "${yayapp[@]}"; do
        echo -e "${fg[green]}[info]${reset_color}$app"
        aur_install $app
    done
}

main
