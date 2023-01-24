#!/bin/sh
DOTFILES_DIR=$(cd $(dirname $0); pwd)

if [ "$(uname)" != "Darwin" ] ; then
    echo "Not MacOS!"
    exit 1
fi

echo "macOS!"

# brew
brew --version >> /dev/null
if [ $? -gt 0 ]; then
    echo "brew is not exists... "
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" >> /dev/null
    brew --version
fi

# git
git version >> /dev/null
if [ $? -gt 0 ]; then
    echo "git is not exists... "
    brew install git
    git version
fi

# fnm : node version manager
# https://github.com/Schniz/fnm
fnm --version >> /dev/null
if [ $? -gt 0 ]; then
    echo "fnm is not exists... "
    curl -fsSL https://fnm.vercel.app/install | zsh >> /dev/null
    fnm --version
fi

# neovim
nvim --version >> /dev/null
if [ $? -gt 0 ]; then
    echo "nvim is not exists... "
    brew install neovim >> /dev/null
    nvim --version
fi
