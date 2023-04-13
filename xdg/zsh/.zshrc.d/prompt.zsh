# zsh prpmpt
## LEFT
function left_prompt(){
  # variables
  local user=$USER

  # 256 color
  # moji
  F_039="%F{039}" # blue
  F_010="%F{010}" # mint
  F_000="%F{000}" # black
  F_002="%F{002}" # green

  # back
  B_008="%K{008}" # gray
  B_004="%K{004}" # blue

  F_END="%f"
  B_END="%k"
  END="${F_END}${B_END}"

  local LINE
  # NAME
  LINE="${F_039}${B_008} 🥹 $user ${END}"
  # DIR
  LINE+="${F_000}${B_004} 📁 %~ ${END}"
  # GIT
  LINE+="${F_002}${B_008} 🌱 $(git_current_branch) ${END}"
  # END
  LINE+="\n${F_039}${B_008} 🐚 >>${END}"

  echo -e $LINE
}

function git_current_branch() {
  local branch_name=$(git branch --show-current 2> /dev/null)

  if [[ -z "$branch_name" ]]; then
    branch_name="No branch"
  fi
  echo "$branch_name"
}

PROMPT=`left_prompt`