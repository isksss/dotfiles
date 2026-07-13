# Repository-managed defaults. User abbreviations remain in zsh-abbr's local file.
if (( $+functions[abbr] )); then
	_define_abbr() {
		abbr --session --quiet --force "$@" >/dev/null 2>&1
	}
else
	_define_abbr() { return 0 }
fi

_define_abbr re="exec ${SHELL} -l"
_define_abbr ..="cd .."

(( $+commands[nvim] )) && _define_abbr n="nvim"

if (( $+commands[eza] )); then
	_define_abbr ls="eza"
	_define_abbr la="eza -a"
	_define_abbr ll="eza -l"
	_define_abbr lla="eza -la"
fi

(( $+commands[bat] )) && _define_abbr cat="bat"
(( $+commands[lazygit] )) && _define_abbr lg="lazygit"
(( $+commands[yazi] )) && _define_abbr yz="yazi"

if (( $+commands[docker] )); then
	_define_abbr d="docker"
	_define_abbr dc="docker compose"
	_define_abbr dce="docker compose exec"
	_define_abbr dps="docker ps"
	_define_abbr di="docker images"
	_define_abbr dcd="docker compose down -v"
	_define_abbr dcup="docker compose up -d"
fi

(( $+commands[lazydocker] )) && _define_abbr ldc="lazydocker"
(( $+commands[zellij] )) && _define_abbr zl="zellij"
(( $+commands[opencode] )) && _define_abbr oc="opencode"

unfunction _define_abbr
