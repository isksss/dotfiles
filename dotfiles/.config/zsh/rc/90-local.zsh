# Machine-specific settings are optional and intentionally untracked.
if [[ -r "$ZDOTDIR/local.zsh" ]]; then
	# Backward compatibility for local files that used the old `_abbr` helper.
	typeset _zsh_abbr_widget=${functions[_abbr]}
	if (( $+functions[abbr] )); then
		_abbr() {
			abbr --session --quiet --force "$@" >/dev/null 2>&1
		}
	else
		_abbr() { return 0 }
	fi
	source "$ZDOTDIR/local.zsh"
	if [[ -n "$_zsh_abbr_widget" ]]; then
		functions[_abbr]=$_zsh_abbr_widget
	else
		unfunction _abbr
	fi
	unset _zsh_abbr_widget
fi

# Interactive abbr commands may reload local changes after startup is complete.
(( $+functions[abbr] )) && typeset -g ABBR_AUTOLOAD=1
