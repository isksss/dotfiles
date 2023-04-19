DOTFILES="$HOME/dotfiles"

# golang
export GOPATH="$HOME/go"
export VOLTA_HOME="$HOME/.volta"

path=(
    $DOTFILES/bin
    $GOPATH/bin
    $VOLTA_HOME/bin
    $path
)
