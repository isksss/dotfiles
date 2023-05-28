DOTFILES=$(cat $HOME/.dotfiles-path)

# golang
export GOPATH="$HOME/go"
export VOLTA_HOME="$HOME/.volta"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

path=(
    $DOTFILES/bin
    $GOPATH/bin
    $VOLTA_HOME/bin
    $HOME/.local/bin
    $HOME/.cargo/env
    $path
)
