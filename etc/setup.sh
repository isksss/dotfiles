#!/usr/bin/env bash
#----- ----- ----- ----- -----
# MyDotfiles
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
export DOTFILES="$HOME/dotfiles"
export XDG_CONFIG_HOME="$HOME/.config" 

#----- ----- ----- ----- -----
# Functions
#----- ----- ----- ----- -----
# import the colors
source "$DOTFILES/etc/util/colors.sh"

# Check if git is installed
function check_git() {
    if command -v git &> /dev/null; then
        error "Git is not installed."
        exit 1
    fi
}
#----- ----- ----- ----- -----
# Main
#----- ----- ----- ----- -----
function main() {
    # Check if git is installed
    check_git
}

main
