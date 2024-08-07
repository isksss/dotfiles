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
#path
export PATH="$GOBIN:$PATH"
export PATH="$AQUA_ROOT_DIR/bin:$PATH"

[[ "$-" != *i* ]] && return

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias grep='grep --color'

alias ll='ls -l'
alias la='ls -A'
