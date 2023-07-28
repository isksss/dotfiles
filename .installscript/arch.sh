#!/bin/bash
if ! grep -q "Arch Linux" /etc/os-release > /dev/null 2>&1; then
    echo "This script is only for Arch Linux"
    exit 1
fi

sudo pacman -Syu

# CLIセットアップ
sudo pacman -S --needed --noconfirm \
    make \
    go \
    vim \
    starship \
    bat \
    exa

if ! command -v yay;then
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ../
    rm -rf yay
fi

yay -S --noconfirm \
    ttf-hackgen

# GUIセットアップ
sudo pacman -S  --noconfirm \
    xorg-xwayland \
    qt5-wayland \
    lightdm \
    lightdm-gtk-greeter \
    sway swaylock swayidle swaybg waybar noto-fonts \
    alacritty \
    mako \
    noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra \
    ttf-font-awesome \
    pipewire wireplumber pipewire-alsa pipewire-pulse pavucontrol playerctl \
    fcitx5 fcitx5-skk fcitx5-im fcitx5-configtool \
    archlinux-wallpaper \
    network-manager-applet \
    thunar gvfs gvfs-smb sshfs tumbler \
    vivaldi

yay -S --noconfirm \
    rofi-lbonn-wayland

