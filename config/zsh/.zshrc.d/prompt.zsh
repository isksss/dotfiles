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

  local LINE=""
  LINE+="${fg[black]}${bg[white]} %~ ${fire} ${reset_color}"
  LINE+="${fg[black]}${bg[white]}${gitmark} `git_current_branch` ${fire} ${reset_color}"
  if [[ -n "$DOCKER_HOST" ]]; then
    LINE+="${fg[black]}${bg[white]}${docker} ${fire} ${reset_color}"
  fi

  LINE+="${fg[white]}${bg[white]}%# ${reset_color}${fg[white]}${shellmark} ${reset_color}"
  LINE+="\n${fg[black]}${bg[white]} $user ${reset_color}${fg[white]}${shellmark} ${reset_color}"

  echo -e $LINE
}

function git_current_branch() {
  local branch_name=$(git branch --show-current 2> /dev/null)

  if [[ -z "$branch_name" ]]; then
    branch_name="No branch"
  fi
  echo "$branch_name"
}

# PROMPT
precmd() {
  PROMPT=`left_prompt`
}

PROMPT=`left_prompt`
