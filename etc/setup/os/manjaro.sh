#!/usr/bin/env bash

#----- ----- ----- ----- -----
# manjaro
#----- ----- ----- ----- -----
# This script is used to setup the dotfiles.
#
# Usage:
#   $DOTFILES/etc/setup.sh
#
# Rquirements:
#   - git
#----- ----- ----- ----- -----

#----- ----- ----- ----- -----
# Variables
#----- ----- ----- ----- -----
# The directory where the dotfiles are located.

#----- ----- ----- ----- -----
# Functions
#----- ----- ----- ----- -----
# import the colors
source "$DOTFILES/etc/util/colors.sh"

function install_pacman(){
    sudo pacman -Sy > /dev/null 2>&1
    info "Install packages for pacman."
    sudo pacman -S --noconfirm --needed \
		yay \
        neovim \
		zsh \
		bat \
		git \
		go \
		> /dev/null

}

function install_aur_packages(){
	yay -Sy > /dev/null 2>&1
	info "Install packages for yay."
	yay -S --noconfirm --needed \
		visual-studio-code-bin \
		google-chrome \
		ttf-hackgen \
		> /dev/null
}

#----- ----- ----- ----- -----
# Main
#----- ----- ----- ----- -----
function main(){
	if [ "$(uname -s)" != "Linux" ] || [ "$(lsb_release -is)" != "ManjaroLinux" ]; then
		echo "This script only works on Manjaro Linux."		
		exit 1
	fi

	install_pacman
	install_aur_packages
}

main
