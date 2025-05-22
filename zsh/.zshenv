# XDG Base Directory Specification
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"

# zsh
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# aqua
export AQUA_ROOT_DIR="${AQUA_ROOT_DIR:-${XDG_DATA_HOME}/aquaproj-aqua}"
export AQUA_GLOBAL_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/aquaproj-aqua/aqua.yaml"
export AQUA_VACUUM_DAYS=30 # 30日以上使用していないツールは削除

# starship
export STARSHIP_CONFIG="${XDG_CONFIG_HOME}/starship.toml"

# path
export PATH="${AQUA_ROOT_DIR}/bin:$PATH"
