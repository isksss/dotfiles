#!/usr/bin/env bash
source "$DOTFILES/etc/util/colors.sh"

function check_zsh(){
    if ! command -v zsh &> /dev/null; then
		error "Zsh not installed."
		return 1
	fi

    return 0
}