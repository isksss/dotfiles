#!/bin/zsh
fnm --version >> /dev/null
if [ $? -gt 0]; then
    curl -fsSL https://fnm.vercel.app/install | bash
fi
