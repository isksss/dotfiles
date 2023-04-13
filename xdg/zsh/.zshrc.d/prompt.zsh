# zsh prpmpt
## LEFT
function left_prompt(){
  # variables
  local user=$USER

  # 256 color
  # moji
  F_NAME="%F{039}" # blue
  F_010="%F{010}" # mint
  F_000="%F{000}" # black
  F_002="%F{040}" # green

  F_NAME="%F{000}"
  B_NAME="%K{067}" # gray

  F_DIR="%F{000}"
  B_DIR="%K{081}"

  F_END="%f"
  B_END="%k"
  END="${F_END}${B_END}"

  local LINE
  # NAME
  LINE="${F_NAME}${B_NAME} 🥹 $user ${END}"
  # DIR
  LINE+="${F_DIR}${B_DIR} 📁 %~ ${END}"
  # GIT
  LINE+="${F_002}${B_NAME} 🌱 $(git_current_branch) ${END}"
  # END
  LINE+="\n${F_NAME}${B_NAME} 🐚 > ${END} "

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