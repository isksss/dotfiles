#############################################################
# environment
#############################################################
# xdg
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache
export XDG_STATE_HOME=$HOME/.local/state
# go
export GOPATH=$XDG_DATA_HOME/go
export GOBIN=$GOPATH/bin
# aqua
export AQUA_ROOT_DIR="$XDG_DATA_HOME/aqua"
export AQUA_GLOBAL_CONFIG="$XDG_CONFIG_HOME/aqua/aqua.yaml"
export AQUA_PROGRESS_BAR=true
export AQUA_LOG_COLOR=always
# starship
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export STARSHIP_CACHE="$XDG_CACHE_HOME/starship/cache"
#zsh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
