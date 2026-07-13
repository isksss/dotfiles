# Core options and persistent shell state.
autoload -Uz add-zsh-hook

typeset -g ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
typeset -g ZSH_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/zsh"

[[ -d "$ZSH_CACHE_DIR" ]] || mkdir -p "$ZSH_CACHE_DIR"
[[ -d "$ZSH_STATE_DIR" ]] || mkdir -p "$ZSH_STATE_DIR"

HISTFILE="$ZSH_STATE_DIR/history"
HISTSIZE=100000
SAVEHIST=100000

# Preserve history from the previous cache-based location on first startup.
if [[ ! -e "$HISTFILE" && -f "$ZSH_CACHE_DIR/.zsh_history" ]]; then
	command cp -p "$ZSH_CACHE_DIR/.zsh_history" "$HISTFILE"
fi

setopt inc_append_history
setopt share_history
setopt hist_fcntl_lock
setopt hist_ignore_all_dups
setopt hist_expire_dups_first
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
setopt extended_history
setopt interactive_comments
setopt auto_menu
setopt complete_in_word
setopt no_beep
