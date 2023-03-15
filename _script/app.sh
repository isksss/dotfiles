#/!bin/sh
set -e
############################################################
# zsh
############################################################

ln -sf $DOTFILES/zsh/.zshrc $HOME/.zshrc
ln -sf $DOTFILES/zsh/.zshenv $HOME/.zshenv
ln -sf $DOTFILES/zsh/.zsh/ $HOME/.zsh

ZSH_SHELL=$(which zsh)
if [ $SHELL != $ZSH_SHELL ]; then
    echo "change shell: $SHELL to $ZSH_SHELL"

    if !(cat /etc/shells | grep $ZSH_SHELL); then 
        echo $ZSH_SHELL >> /etc/shells
    fi
    chsh -s $ZSH_SHELL
fi

if [ -d /$DOTFILES/zsh/.zsh/.zsh ]; then
    rm -rf $DOTFILES/zsh/.zsh/.zsh
fi
############################################################
# git
############################################################

ln -sf $DOTFILES/git/.gitconfig $HOME/.gitconfig
ln -sf $DOTFILES/git/.gitignore_global $HOME/.gitignore_global

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
    git clone https://github.com/wbthomason/packer.nvim $packer_dir
fi

# smbolic link
rm -rf $NVIM_HOME/*
ln -sf $NVIM_DIR/init.lua $NVIM_HOME/init.lua
ln -sf $NVIM_DIR/lua/ $NVIM_HOME/lua
ln -sf $NVIM_DIR/coc-settings.json $NVIM_HOME/coc-settings.json
