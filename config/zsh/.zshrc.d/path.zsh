DOTFILES=$(cat $HOME/.dotfiles-path)

# golang
export GOPATH="$HOME/go"
export VOLTA_HOME="$HOME/.volta"
export RYE_HOME="$HOME/.rye"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

path=(
    $DOTFILES/bin
    $GOPATH/bin
    $VOLTA_HOME/bin
    $RYE_HOME/shims
    $HOME/.local/bin
    $HOME/.cargo/env
    $path
)
