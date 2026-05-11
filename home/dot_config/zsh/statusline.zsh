setopt prompt_subst
_statusline_os_icon() {
  local os id
  os=$(uname -s)
  case $os in
    Darwin)
      printf '\xef\x8c\x82'  # U+F302  macOS
      return
      ;;
    FreeBSD)   printf '\xef\x8c\x8c'; return ;;  # U+F30C
    OpenBSD)   printf '\xef\x8c\xa8'; return ;;  # U+F328
    NetBSD)    printf '\xef\x80\xa4'; return ;;  # U+F024
    DragonFly) printf '\xee\x8a\x8e'; return ;;  # U+E28E
    Linux) ;;
    *)         printf '\xef\x8c\x9a'; return ;;  # U+F31A  Unknown
  esac

  # Linux: detect distro via /etc/os-release
  if [[ -f /etc/os-release ]]; then
    id=$(. /etc/os-release; echo "$ID")
  fi
  case $id in
    aix)          printf '\xee\xa3\x8c' ;;  # U+E8CC
    almalinux)    printf '\xef\x8c\x9d' ;;  # U+F31D
    alpine)       printf '\xef\x8c\x80' ;;  # U+F300
    altlinux)     printf '\xef\x8c\x9a' ;;  # U+F31A
    amzn)         printf '\xef\x89\xb0' ;;  # U+F270  Amazon
    android)      printf '\xef\x85\xbb' ;;  # U+F17B
    aosc)         printf '\xef\x8c\x81' ;;  # U+F301
    arch)         printf '\xef\x8c\x83' ;;  # U+F303
    artix)        printf '\xef\x8c\x9f' ;;  # U+F31F
    centos)       printf '\xef\x8c\x84' ;;  # U+F304
    debian)       printf '\xef\x8c\x86' ;;  # U+F306
    elementary)   printf '\xef\x8c\x89' ;;  # U+F309
    endeavouros)  printf '\xef\x8c\xa2' ;;  # U+F322
    fedora)       printf '\xef\x8c\x8a' ;;  # U+F30A
    garuda)       printf '\xef\x8c\xb7' ;;  # U+F337
    gentoo)       printf '\xef\x8c\x8d' ;;  # U+F30D
    hardenedbsd)  printf '\xf3\xb0\x9e\x8c' ;;  # U+F078C
    illumos)      printf '\xef\x8c\xa6' ;;  # U+F326
    kali)         printf '\xef\x8c\xa7' ;;  # U+F327
    linuxmint)    printf '\xef\x8c\x8e' ;;  # U+F30E  Mint
    manjaro)      printf '\xef\x8c\x92' ;;  # U+F312
    nixos)        printf '\xef\x8c\x93' ;;  # U+F313
    nobara)       printf '\xef\x8e\x80' ;;  # U+F380
    opensuse-leap|opensuse-tumbleweed|opensuse*)
                  printf '\xef\x8c\x94' ;;  # U+F314
    ol)           printf '\xf3\xb0\xba\xa1' ;;  # U+F0EA1  OracleLinux
    pop)          printf '\xef\x8c\xaa' ;;  # U+F32A  Pop!_OS
    raspbian)     printf '\xef\x8c\x95' ;;  # U+F315
    rhel)         printf '\xf3\xb1\x84\x9b' ;;  # U+F111B  RedHat
    rocky)        printf '\xef\x8c\xab' ;;  # U+F32B
    solus)        printf '\xef\x8c\xad' ;;  # U+F32D
    suse)         printf '\xef\x8c\x94' ;;  # U+F314
    ubuntu)       printf '\xef\x8c\x9b' ;;  # U+F31B
    uos)          printf '\xef\x8c\xa1' ;;  # U+F321
    void)         printf '\xef\x8c\xae' ;;  # U+F32E
    zorin)        printf '\xef\x8c\xaf' ;;  # U+F32F
    *)            printf '\xef\x8c\x9a' ;;  # U+F31A  Linux generic
  esac
}
_statusline_in_docker() {
  [[ -f /.dockerenv ]] && return 0
  [[ -r /proc/1/cgroup ]] && grep -q 'docker\|containerd\|kubepods' /proc/1/cgroup 2>/dev/null && return 0
  return 1
}
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
  p+="%K{#a3aed2}%F{#090c0c} $( _statusline_in_docker && printf '\xef\x84\xb8 ' )$(_statusline_os_icon) %f%k"
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
