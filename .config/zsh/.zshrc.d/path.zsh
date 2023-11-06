export GOPATH="$HOME/go"
export VOLTA_HOME="$HOME/.volta"
export RYE_HOME="$HOME/.rye"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export PRIVATE_BIN="$XDG_CONFIG_HOME/private_bin"

chmod +x $PRIVATE_BIN/*

path=(
    $GOPATH/bin
    $VOLTA_HOME/bin
    $RYE_HOME/shims
    $HOME/.local/bin
    $HOME/.cargo/bin
    $PRIVATE_BIN
    $HOME/bin
    $path
)