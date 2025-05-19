# PATH 追加関数
add_path() {
    local new_path="$1"
    path=("$new_path" $path)
}

# XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# ツール用環境変数
export AQUA_ROOT_DIR="${XDG_DATA_HOME}/aquaproj-aqua/"
export AQUA_GLOBAL_CONFIG="$HOME/aqua.yaml"
export AQUA_PROGRESS_BAR=true
export AQUA_LOG_COLOR=always
export AQUA_REMOVE_MODE=pl
export _ZO_DOCTOR=0
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# PATH
add_path "$HOME/.cargo/bin"
add_path "$AQUA_ROOT_DIR/bin"

unset -f add_path
