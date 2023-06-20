# zsh prpmpt
autoload -U colors; colors
## LEFT
function left_prompt(){
  # variables
  local user="\uE228"
  local fire="\uE0B1"
  local gitmark="\uE0A0"

  local shellmark="\uE0B0"
  local docker="\ue7b0"
  local apple="\ue711"
  local arch="\uf303"
  local git_user="\uf2bd"

  local LINE=""
  LINE+="${fg[black]}${bg[white]} %~ ${fire} ${reset_color}"
  LINE+="${fg[black]}${bg[white]}${gitmark} `git_current_branch` ${fire} ${reset_color}"
  # Docker
  # /.dockerenvがあるかどうかで判定
  if [[ -f /.dockerenv ]]; then
    LINE+="${fg[blue]}${bg[white]}${docker} ${fg[black]}${fire} ${reset_color}"
  fi

  # mac
  if [[ $(uname -s) == "Darwin" ]]; then
    LINE+="${fg[magenta]}${bg[white]}${apple} ${fg[black]}${fire} ${reset_color}"
  elif [[ $(uname -s) == "Linux" ]]; then
    # archか確認
    if [[ -f /etc/arch-release ]]; then
      LINE+="${fg[cyan]}${bg[white]}${arch}  ${fg[black]}${fire} ${reset_color}"
    fi
  fi

  LINE+="${fg[black]}${bg[white]}%# ${reset_color}${fg[white]}${shellmark} ${reset_color}"
  LINE+="\n${fg[black]}${bg[white]} $user ${reset_color}${fg[white]}${shellmark} ${reset_color}"

  echo -e $LINE
}

function git_current_branch() {
  local branch_name=$(git branch --show-current 2> /dev/null)
  local git_user=$(git config --get user.name)

  return_code=""

  if [[ -z "$branch_name" ]]; then
    branch_name="No branch"
    return_code="$branch_name"
  else
    return_code="$branch_name"
  fi
  echo "$branch_name"
}

# PROMPT
precmd() {
  PROMPT=`left_prompt`
}

PROMPT=`left_prompt`
