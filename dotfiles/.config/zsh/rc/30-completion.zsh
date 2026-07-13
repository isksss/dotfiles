# Cache generated completion functions under XDG_CACHE_HOME.
typeset -g ZSH_COMPLETION_DIR="$ZSH_CACHE_DIR/completions"
[[ -d "$ZSH_COMPLETION_DIR" ]] || mkdir -p "$ZSH_COMPLETION_DIR"

_cache_completion() {
	local command_name=$1 target=$2
	shift 2

	local executable=${commands[$command_name]}
	[[ -n "$executable" ]] || return 0
	[[ -s "$target" && ! "$executable" -nt "$target" ]] && return 0

	local temporary="${target}.tmp.$$"
	if command "$@" >|"$temporary" 2>/dev/null; then
		command mv -f "$temporary" "$target"
	else
		command rm -f "$temporary"
	fi
}

_cache_completion mise "$ZSH_COMPLETION_DIR/_mise" mise completion zsh
_cache_completion docker "$ZSH_COMPLETION_DIR/_docker" docker completion zsh
_cache_completion wtp "$ZSH_COMPLETION_DIR/_wtp" wtp completion zsh
_cache_completion gh "$ZSH_COMPLETION_DIR/_gh" gh completion -s zsh
_cache_completion glab "$ZSH_COMPLETION_DIR/_glab" glab completion -s zsh
_cache_completion chezmoi "$ZSH_COMPLETION_DIR/_chezmoi" chezmoi completion zsh
_cache_completion sqio "$ZSH_COMPLETION_DIR/_sqio" sqio completion zsh
_cache_completion gwq "$ZSH_COMPLETION_DIR/_gwq" gwq completion zsh

fpath=("$ZSH_COMPLETION_DIR" $fpath)
autoload -Uz compinit

typeset -g ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"
zmodload zsh/datetime
zmodload zsh/stat
typeset -a _zcompdump_stat
zstat -A _zcompdump_stat +mtime -- "$ZSH_COMPDUMP" 2>/dev/null
if [[ -s "$ZSH_COMPDUMP" ]] && (( EPOCHSECONDS - ${_zcompdump_stat[1]:-0} < 86400 )); then
	compinit -C -d "$ZSH_COMPDUMP"
else
	compinit -d "$ZSH_COMPDUMP"
fi

unfunction _cache_completion
unset _zcompdump_stat
