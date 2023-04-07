#!/usr/bin/env bash
source "$DOTFILES/etc/util/colors.sh"

# Change shell Zsh
function _chsh_zsh(){
    if ! command -v zsh &> /dev/null; then
		error "Zsh not installed."
		exit 1
	fi

    local zsh_shell="$(which zsh)"
    if [ "$SHELL" = "$zsh_shell" ]; then
        warning "Zsh is already configured"
        return
    fi

    info "Change shell from $SHELL to $zsh_shell"
    chsh -s $zsh_shell
    
}

_chsh_zsh