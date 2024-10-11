#############################################################
# environment
#############################################################
# xdg
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
# go
export GOPATH="$XDG_DATA_HOME/go"
export GOBIN="$GOPATH/bin"
# aqua
export AQUA_ROOT_DIR="$XDG_DATA_HOME/aqua"
export AQUA_GLOBAL_CONFIG="$XDG_CONFIG_HOME/aqua/aqua.yaml"
export AQUA_PROGRESS_BAR=true
export AQUA_LOG_COLOR=always
# starship
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export STARSHIP_CACHE="$XDG_CACHE_HOME/starship/cache"
# zoxide
export _ZO_DATA_DIR="$XDG_DATA_HOME/zoxide"
# ripgrep
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/.ripgreprc"
# deno
export DENO_DIR="$XDG_CACHE_HOME/deno"
export DENO_INSTALL_ROOT="$XDG_DATA_HOME/deno"
# volta
export VOLTA_HOME="$HOME/.volta"
# zsh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
# workspace
export WORKSPACE="$HOME/workspace"
# dotfiles
export DOTFILES_REPO_PATH="$HOME/.dotfiles"
# editor
export EDITOR=nvim

#############################################################
# path
#############################################################
path=(
    $AQUA_ROOT_DIR/bin(N-/)
    $GOBIN(N-/)
    $DENO_INSTALL_ROOT/bin(N-/)
    $VOLTA_HOME/bin(N-/)
    $path
)
. "$HOME/.cargo/env"
