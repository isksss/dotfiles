setopt prompt_subst

typeset -g STATUSLINE_SEPARATOR=''
typeset -gA STATUSLINE_DIR_SUBSTITUTIONS
STATUSLINE_DIR_SUBSTITUTIONS=(
  Documents '󰈙 '
  Downloads ' '
  Music ' '
  Pictures ' '
)

_statusline_truncate_path() {
  local raw path
  local -a parts tail

  raw=${PWD/#$HOME/~}
  parts=(${(s:/:)raw})

  if (( ${#parts} > 3 )); then
    tail=(${parts[-3,-1]})
    if [[ $parts[1] == '~' ]]; then
      path="~/${(j:/:)tail}"
    else
      path="…/${(j:/:)tail}"
    fi
  else
    path=$raw
  fi

  local -a out
  local part
  local sep=''
  out=()
  for part in ${(s:/:)path}; do
    if [[ -n ${STATUSLINE_DIR_SUBSTITUTIONS[$part]} ]]; then
      out+=(${STATUSLINE_DIR_SUBSTITUTIONS[$part]})
    else
      out+=($part)
    fi
  done

  local joined=''
  local item
  for item in ${out[@]}; do
    joined+="${sep}${item}"
    sep='/'
  done

  print -r -- "$joined"
}

_statusline_git_branch() {
  command git symbolic-ref --quiet --short HEAD 2>/dev/null || command git rev-parse --short HEAD 2>/dev/null
}

_statusline_git_status() {
  local line xy ahead behind
  local staged=0 modified=0 deleted=0 untracked=0 conflicted=0

  while IFS= read -r line; do
    if [[ $line == '## '* ]]; then
      if [[ $line =~ 'ahead ([0-9]+)' ]]; then
        ahead=${match[1]}
      fi
      if [[ $line =~ 'behind ([0-9]+)' ]]; then
        behind=${match[1]}
      fi
      continue
    fi

    if [[ $line == '?? '* ]]; then
      ((untracked++))
      continue
    fi

    xy=${line[1,2]}

    if [[ $xy == *U* || $xy == UU || $xy == AA || $xy == DD ]]; then
      ((conflicted++))
      continue
    fi

    if [[ ${xy[1]} != ' ' ]]; then
      ((staged++))
    fi
    if [[ ${xy[2]} != ' ' ]]; then
      ((modified++))
    fi
    if [[ $xy == *D* ]]; then
      ((deleted++))
    fi
  done < <(command git status --porcelain --branch 2>/dev/null)

  local out=''
  [[ -n $ahead ]] && out+="⇡${ahead}"
  [[ -n $behind ]] && out+="${out:+ }⇣${behind}"
  (( staged > 0 )) && out+="${out:+ }+${staged}"
  (( modified > 0 )) && out+="${out:+ }!${modified}"
  (( deleted > 0 )) && out+="${out:+ }x${deleted}"
  (( untracked > 0 )) && out+="${out:+ }?${untracked}"
  (( conflicted > 0 )) && out+="${out:+ }=${conflicted}"

  print -r -- "$out"
}

_statusline_node_segment() {
  [[ -f package.json ]] || return 0
  command -v node >/dev/null 2>&1 || return 0
  local version
  version=$(command node -v 2>/dev/null)
  print -r -- "%K{#212736}%F{#769ff0}  (${version}) %f%k"
}

_statusline_rust_segment() {
  [[ -f Cargo.toml ]] || return 0
  command -v rustc >/dev/null 2>&1 || return 0
  local version
  version=$(command rustc --version 2>/dev/null | awk '{print $2}')
  print -r -- "%K{#212736}%F{#769ff0}  (v${version}) %f%k"
}

_statusline_go_segment() {
  [[ -f go.mod ]] || return 0
  command -v go >/dev/null 2>&1 || return 0
  local version
  version=$(command go version 2>/dev/null | awk '{print $3}')
  print -r -- "%K{#212736}%F{#769ff0}  (${version}) %f%k"
}

_statusline_php_segment() {
  [[ -f composer.json ]] || return 0
  command -v php >/dev/null 2>&1 || return 0
  local version
  version=$(command php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION.".".PHP_RELEASE_VERSION;' 2>/dev/null)
  print -r -- "%K{#212736}%F{#769ff0}  (v${version}) %f%k"
}

_statusline_precmd() {
  local last_status=$?
  local branch git_state dir
  local p

  dir=$(_statusline_truncate_path)
  branch=$(_statusline_git_branch)

  p=''
  p+="%F{#a3aed2}░▒▓%f"
  p+="%K{#a3aed2}%F{#090c0c}  %f%k"
  p+="%F{#a3aed2}%K{#769ff0}${STATUSLINE_SEPARATOR}%f%k"
  p+="%K{#769ff0}%F{#e3e5e5} ${dir} %f%k"

  p+="%F{#769ff0}%K{#394260}${STATUSLINE_SEPARATOR}%f%k"
  if [[ -n $branch ]]; then
    git_state=$(_statusline_git_status)
    p+="%K{#394260}%F{#769ff0}  ${branch}"
    [[ -n $git_state ]] && p+=" ${git_state}"
    p+=" %f%k"
  fi

  p+="%F{#394260}%K{#212736}${STATUSLINE_SEPARATOR}%f%k"
  p+="$(_statusline_node_segment)"
  p+="$(_statusline_rust_segment)"
  p+="$(_statusline_go_segment)"
  p+="$(_statusline_php_segment)"

  p+="%F{#212736}%K{#1d2230}${STATUSLINE_SEPARATOR}%f%k"
  p+="%K{#1d2230}%F{#a0a9cb}  $(date +%R) %f%k"
  p+="%F{#1d2230}${STATUSLINE_SEPARATOR} %f"
  p+=$'\n'

  if (( last_status == 0 )); then
    p+="%F{green}%#%f "
  else
    p+="%F{red}%#%f "
  fi

  PROMPT=$p
}

if (( ${precmd_functions[(I)_statusline_precmd]} == 0 )); then
  precmd_functions+=(_statusline_precmd)
fi
