export GOPATH="$HOME/go"
export VOLTA_HOME="$HOME/.volta"
export RYE_HOME="$HOME/.rye"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"


path=(
    $GOPATH/bin
    $VOLTA_HOME/bin
    $RYE_HOME/shims
    $HOME/.local/bin
    $HOME/.cargo/bin
    $path
)