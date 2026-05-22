# lang
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8

# XDG Base Directory Specification
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"
export XDG_RUNTIME_DIR="/tmp"

# zsh
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# EDITOR
export EDITOR="vim"

# starship
export STARSHIP_CONFIG="${XDG_CONFIG_HOME}/starship.toml"
