#/!bin/sh
set -e
############################################################
# zsh
############################################################

############################################################
# neovim
############################################################
NVIM_DIR=$DOTFILES/.config/nvim
NVIM_HOME=$XDG_CONFIG_HOME/nvim

if [ ! -d "$NVIM_HOME" ]; then
    echo "mkdir: $NVIM_HOME"
    mkdir -p "$NVIM_HOME" &>/dev/null
fi

# Clone required repositories
packer_dir="$HOME/.local/share/nvim/site/pack/packer/opt/packer.nvim"
if [ ! -d $packer_dir ]; then
    echo "git clone packer.nvim"
    git clone https://github.com/wbthomason/packer.nvim $packer_dir &>/dev/null
fi

# smbolic link
rm -rf $NVIM_HOME/*
ln -sf $NVIM_DIR/init.lua $NVIM_HOME/init.lua
ln -sf $NVIM_DIR/lua/ $NVIM_HOME/lua/
ln -sf $NVIM_DIR/coc-settings.json $NVIM_HOME/coc-settings.json
