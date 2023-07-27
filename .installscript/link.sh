#!/bin/bash
# symlink

## variable
XDG_CONFIG_HOME="${HOME}/.config"
DOTFILES=`cat ${HOME}/.dotfiles-path`
## config

array=($(ls $DOTFILES/config))
for configdir in ${array[@]}; do
    ln -sf "$DOTFILES/config/$configdir" "$XDG_CONFIG_HOME/$configdir"
    if [ -d "$DOTFILES/config/$configdir/$configdir" ]; then
        unlink "$XDG_CONFIG_HOME/$configdir/$configdir"
    fi
done
### zsh
ln -sf "$DOTFILES/config/zsh/.zshenv" "$HOME/.zshenv"

### bash
ln -sf "$DOTFILES/config/bash/.bashrc" "$HOME/.bashrc"

### xprofile
ln -sf "$DOTFILES/config/x/.xprofile" "$HOME/.xprofile"
ln -sf "$DOTFILES/config/x/.Xdefault" "$HOME/.Xdefault"

