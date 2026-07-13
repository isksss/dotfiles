# Two-line prompt with per-session runtime caches.
setopt prompt_subst

typeset -g STATUSLINE_SEPARATOR=''
typeset -gA STATUSLINE_DIR_SUBSTITUTIONS=(
	Documents '󰈙 '
	Downloads ' '
	Music ' '
	Pictures ' '
)
typeset -gA STATUSLINE_RUNTIME_VERSIONS

_statusline_os_icon() {
	local os id
	os=$(uname -s)
	case $os in
	Darwin) printf '\xef\x8c\x82'; return ;;
	FreeBSD) printf '\xef\x8c\x8c'; return ;;
	OpenBSD) printf '\xef\x8c\xa8'; return ;;
	NetBSD) printf '\xef\x80\xa4'; return ;;
	DragonFly) printf '\xee\x8a\x8e'; return ;;
	Linux) ;;
	*) printf '\xef\x8c\x9a'; return ;;
	esac

	if [[ -f /etc/os-release ]]; then
		id=$(. /etc/os-release; echo "$ID")
	fi
	case $id in
	aix) printf '\xee\xa3\x8c' ;;
	almalinux) printf '\xef\x8c\x9d' ;;
	alpine) printf '\xef\x8c\x80' ;;
	amzn) printf '\xef\x89\xb0' ;;
	android) printf '\xef\x85\xbb' ;;
	arch) printf '\xef\x8c\x83' ;;
	artix) printf '\xef\x8c\x9f' ;;
	centos) printf '\xef\x8c\x84' ;;
	debian) printf '\xef\x8c\x86' ;;
	endeavouros) printf '\xef\x8c\xa2' ;;
	fedora) printf '\xef\x8c\x8a' ;;
	gentoo) printf '\xef\x8c\x8d' ;;
	kali) printf '\xef\x8c\xa7' ;;
	linuxmint) printf '\xef\x8c\x8e' ;;
	manjaro) printf '\xef\x8c\x92' ;;
	nixos) printf '\xef\x8c\x93' ;;
	opensuse*) printf '\xef\x8c\x94' ;;
	pop) printf '\xef\x8c\xaa' ;;
	raspbian) printf '\xef\x8c\x95' ;;
	rhel) printf '\xf3\xb1\x84\x9b' ;;
	rocky) printf '\xef\x8c\xab' ;;
	ubuntu) printf '\xef\x8c\x9b' ;;
	void) printf '\xef\x8c\xae' ;;
	*) printf '\xef\x8c\x9a' ;;
	esac
}

typeset -g STATUSLINE_OS_ICON=$(_statusline_os_icon)

_statusline_in_docker() {
	[[ -f /.dockerenv ]] && return 0
	[[ -r /proc/1/cgroup ]] && grep -q 'docker\|containerd\|kubepods' /proc/1/cgroup 2>/dev/null
}

_statusline_truncate_path() {
	local current part display separator=''
	local -a parts tail output

	[[ $PWD == $HOME ]] && { print -r -- '~'; return; }
	current=${PWD/#$HOME/~}
	parts=(${(s:/:)current})
	if ((${#parts} > 3)); then
		tail=(${parts[-3,-1]})
		current="…/${(j:/:)tail}"
	fi

	for part in ${(s:/:)current}; do
		if [[ -n ${STATUSLINE_DIR_SUBSTITUTIONS[$part]} ]]; then
			display=${STATUSLINE_DIR_SUBSTITUTIONS[$part]}
		elif ((${#part} > 10)); then
			display="${part[1,6]}…"
		else
			display=$part
		fi
		output+=($display)
	done

	current=''
	for display in ${output[@]}; do
		current+="${separator}${display}"
		separator='/'
	done
	print -r -- "$current"
}

_statusline_git() {
	local line branch='' oid='' xy ahead behind
	local staged=0 modified=0 deleted=0 untracked=0 conflicted=0

	while IFS= read -r line; do
		case $line in
		'# branch.head '*) branch=${line#\# branch.head } ;;
		'# branch.oid '*) oid=${line#\# branch.oid } ;;
		'# branch.ab '*)
			ahead=${${line#*+}%% *}
			behind=${line##*-}
			;;
		'? '*) ((untracked++)) ;;
		'u '*) ((conflicted++)) ;;
		[12]' '*)
			xy=${${(s: :)line}[2]}
			[[ ${xy[1]} != '.' ]] && ((staged++))
			[[ ${xy[2]} != '.' ]] && ((modified++))
			[[ $xy == *D* ]] && ((deleted++))
			;;
		esac
	done < <(command git status --porcelain=v2 --branch 2>/dev/null)

	[[ -z "$branch" || "$branch" == '(detached)' ]] && branch=${oid[1,7]}
	[[ -n "$branch" ]] || return 0

	local state=''
	((ahead > 0)) && state+="⇡${ahead}"
	((behind > 0)) && state+="${state:+ }⇣${behind}"
	((staged > 0)) && state+="${state:+ }+${staged}"
	((modified > 0)) && state+="${state:+ }!${modified}"
	((deleted > 0)) && state+="${state:+ }x${deleted}"
	((untracked > 0)) && state+="${state:+ }?${untracked}"
	((conflicted > 0)) && state+="${state:+ }=${conflicted}"
	print -r -- "$branch|$state"
}

_statusline_runtime_version() {
	local name=$1
	shift
	if [[ -z ${STATUSLINE_RUNTIME_VERSIONS[$name]} ]]; then
		STATUSLINE_RUNTIME_VERSIONS[$name]=$(command "$@" 2>/dev/null)
	fi
	print -r -- "${STATUSLINE_RUNTIME_VERSIONS[$name]}"
}

_statusline_runtime_segments() {
	local version=''
	if [[ -f package.json ]] && (( $+commands[node] )); then
		version=$(_statusline_runtime_version node node -v)
		print -n -- "%K{#212736}%F{#769ff0}  (${version}) %f%k"
	fi
	if [[ -f Cargo.toml ]] && (( $+commands[rustc] )); then
		version=$(_statusline_runtime_version rust rustc --version)
		version=${${(s: :)version}[2]}
		print -n -- "%K{#212736}%F{#769ff0}  (v${version}) %f%k"
	fi
	if [[ -f go.mod ]] && (( $+commands[go] )); then
		version=$(_statusline_runtime_version go go version)
		version=${${(s: :)version}[3]}
		print -n -- "%K{#212736}%F{#769ff0}  (${version}) %f%k"
	fi
	if [[ -f composer.json ]] && (( $+commands[php] )); then
		version=$(_statusline_runtime_version php php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION.".".PHP_RELEASE_VERSION;')
		print -n -- "%K{#212736}%F{#769ff0}  (v${version}) %f%k"
	fi
}

_statusline_precmd() {
	local last_status=$? dir git_info branch git_state p
	dir=$(_statusline_truncate_path)
	git_info=$(_statusline_git)
	branch=${git_info%%|*}
	git_state=${git_info#*|}
	[[ $git_info == *'|'* ]] || { branch=''; git_state=''; }

	p="%F{#a3aed2}░▒▓%f"
	p+="%K{#a3aed2}%F{#090c0c} $(_statusline_in_docker && printf '\xef\x84\xb8 ')${STATUSLINE_OS_ICON} %f%k"
	p+="%F{#a3aed2}%K{#769ff0}${STATUSLINE_SEPARATOR}%f%k"
	p+="%K{#769ff0}%F{#e3e5e5} ${dir} %f%k"
	p+="%F{#769ff0}%K{#394260}${STATUSLINE_SEPARATOR}%f%k"
	if [[ -n $branch ]]; then
		p+="%K{#394260}%F{#769ff0} 󰊢 ${branch}"
		[[ -n $git_state ]] && p+=" ${git_state}"
		p+=" %f%k"
	fi
	p+="%F{#394260}%K{#212736}${STATUSLINE_SEPARATOR}%f%k"
	p+="$(_statusline_runtime_segments)"
	p+="%F{#212736}%K{#1d2230}${STATUSLINE_SEPARATOR}%f%k"
	p+="%K{#1d2230}%F{#a0a9cb}  $(date +%R) %f%k"
	p+="%F{#1d2230}${STATUSLINE_SEPARATOR} %f"
	p+=$'\n'
	((last_status == 0)) && p+="%F{green}%#%f " || p+="%F{red}%#%f "
	PROMPT=$p
}

add-zsh-hook precmd _statusline_precmd
