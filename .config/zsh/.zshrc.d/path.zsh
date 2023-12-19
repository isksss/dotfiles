export GOPATH="$HOME/go"
export VOLTA_HOME="$HOME/.volta"
export RYE_HOME="$HOME/.rye"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

export DENO_INSTALL="$HOME/.deno"
export PYENV_ROOT="$HOME/.pyenv"

path=(
    $GOPATH/bin
    $VOLTA_HOME/bin
    $RYE_HOME/shims
    $HOME/.local/bin
    $HOME/.cargo/bin
    $DENO_INSTALL/bin
    $PYENV_ROOT/bin
    $HOME/bin
    $path
)