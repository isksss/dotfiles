# Tool and plugin initialization required by later modules.
if [[ -f "$HOME/.cargo/env" ]]; then
	source "$HOME/.cargo/env"
fi

if (( $+commands[mise] )); then
	eval "$(mise activate zsh)"
fi

# Load the local abbreviation file once. Declarative abbreviations are session-only.
typeset -g ABBR_AUTOLOAD=0
if (( $+commands[sheldon] )); then
	eval "$(sheldon source)"
fi
