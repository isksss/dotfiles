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
export DOTFILES="$HOME/dotfiles"
export WORKSPACE="$HOME/workspace"

export XDG_CONFIG_HOME="$HOME/.config" 
export XDG_CACHE_HOME="$HOME/.cache"

export REMOTE_URL="https://github.com/isksss/dotfiles.git"
export SSH_URL="git@github.com:isksss/dotfiles.git"

#----- ----- ----- ----- -----
# Functions
#----- ----- ----- ----- -----
# import the colors
source "$DOTFILES/etc/util/colors.sh"

# Check if git is installed
function check_git() {
	if ! command -v git &> /dev/null; then
		error "Git is not installed."
		exit 1
	fi
}

function clone_dotfiles() {
	if [ -d  $DOTFILES ];then
		warning "Dotfiles is exists."
		return
	fi
	#echo "$DOTFILES is not exists"
	info "Clone $REMOTE_URL"
	git clone $REMOTE_URL $DOTFILES > /dev/null 2>&1

	info "Change dotfiles remote url"
	info "$REMOTE_URL -> $SSH_URL"
	git remote set-url origin $SSH_URL
}

function os_specific_action() {
  local os=$(uname -s)
  local lsb=$(lsb_release -is)

  case "$os" in
    Linux*)
		if [ $lsb = "ManjaroLinux" ]; then
			info "$lsb"
			chmod +x "$DOTFILES/etc/setup/os/manjaro.sh"
			$DOTFILES/etc/setup/os/manjaro.sh
			return
		fi
      ;;
    Darwin*)
    	info "Mac OS"
		chmod +x "$DOTFILES/etc/setup/os/macos.sh"
		$DOTFILES/etc/setup/os/macos.sh
		return
    	;;
    *)
    	error "This script can only be executed on Linux or Mac OS."
		exit 1
    	;;
  esac
}

#----- ----- ----- ----- -----
# Main
#----- ----- ----- ----- -----
function main() {
	# Check if git is installed
	check_git
	
	# Clone dotfiles
	clone_dotfiles

	# It performs different actions for each operating system.
	os_specific_action

	# Make Workspace
	mkdir -p $WORKSPACE

	# symlink
	chmod +x "$DOTFILES/etc/setup/symlink.sh"
	$DOTFILES/etc/setup/symlink.sh

	# zsh
	chmod +x "$DOTFILES/etc/setup/chsh_zsh.sh"
	$DOTFILES/etc/setup/chsh_zsh.sh

	# delete all symbolick link
	chmod +x "$DOTFILES/etc/setup/del_sym.sh"
	$DOTFILES/etc/setup/del_sym.sh

	info "Setup has been completed."
}

main
