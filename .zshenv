
## XDG Base Directory Specification
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache

## editor
export EDITOR=nvim

## Zsh
export ZDOTDIR=$XDG_CONFIG_HOME/zsh
## go
export GOROOT=$HOME/.local/bin
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
## rust
export CARGO_HOME=$HOME/.cargo
## deno
export DENO_INSTALL=$HOME/.deno
## volta
export VOLTA_HOME=$HOME/.volta
## rye
export RYE_HOME="$HOME/.rye"
## proto
export PROTO_HOME="$HOME/.proto"

## path
path=(
    $HOME/.local/bin
    $DENO_INSTALL/bin
    $CARGO_HOME/bin
    $GOBIN
    $VOLTA_HOME/bin
    $RYE_HOME/shims
    $PROTO_HOME/shims
    $PROTO_HOME/bin
    $path
)
