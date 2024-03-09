
## XDG Base Directory Specification
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache

## Zsh
export ZDOTDIR=$XDG_CONFIG_HOME/zsh
## go
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

## path
path=(
    $HOME/.local/bin
    $DENO_INSTALL/bin
    $CARGO_HOME/bin
    $GOBIN
    $VOLTA_HOME/bin
    $RYE_HOME/shims
    $path
)
