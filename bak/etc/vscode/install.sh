#!/usr/bin/env bash

DOTFILES_DIR="$HOME/dotfiles"
XDG_CONFIG_HOME="$HOME/.config"

# CODE_DIR="$XDG_CONFIG_HOME/Code"
# CODE_BACKUP_DIR="$XDG_CONFIG_HOME/Code_Back"

# if [ -d "$CODE_BACKUP_DIR" ]; then
#     echo "back up file delete"
#     rm -rf $CODE_BACKUP_DIR
# fi

# echo "vscode backup"
# mv $CODE_DIR $CODE_BACKUP_DIR
mkdir -p $CODE_DIR/User

ln -sf $DOTFILES_DIR/.config/Code/User $CODE_DIR/User