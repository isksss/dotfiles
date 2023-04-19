# zsh prpmpt
## LEFT
function left_prompt(){
  # variables
  local user=$USER
  local fire="\uE0C1"
  local gitmark="\uE0A0"

  local endmark="\uE0C0"
  local shellmark="\uE0B0"
  # 256 color
  # moji
  F_NAME="%F{039}" # blue
  F_010="%F{010}" # mint
  F_000="%F{000}" # black
  F_002="%F{040}" # green

  F_NAME="%F{000}"
  B_NAME="%K{067}" # gray

  S_COLOR="%F{067}"
  F_DIR="%F{000}"
  B_DIR="%K{081}"

  F_END="%f"
  B_END="%k"
  END="${F_END}${B_END}"

  local LINE=""
  # DIR
  LINE+="${F_DIR}${B_NAME} %~ $fire ${END}"
  # GIT
  LINE+="${F_002}${B_NAME} $gitmark $(git_current_branch) ${F_END}${F_000}$fire ${END}"
  # mark
  LINE+="${F_000}${B_NAME}  %# ${END}${S_COLOR}$endmark${END}"
  # END
  LINE+="\n${S_COLOR}${B_NAME} 👻 ${B_END}$shellmark${END} "

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
