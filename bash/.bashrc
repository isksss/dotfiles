if [ -t 1 ];then
    exec zsh
fi
. "$HOME/.cargo/env"
