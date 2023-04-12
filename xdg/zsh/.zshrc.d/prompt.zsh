# zsh prpmpt
## LEFT
function left_prompt(){
    # variables
    local user=$USER

    # icon
    local icon_arrow="\ue0b0"
    local icon_manjaro="\uf312"
    local icon_git_branch="\ue0a0"

    # Get the OS mark
    local os_mark=$(get_os_mark)
    local OS=""
    if [[ -n $os_mark ]]; then
        OS="${bg[blue]}${fg[white]}$os_mark${reset_color} "
    fi
    local NAME=""
    echo $OS$USER %m $icon_arrow
}

# Check the OS and return the corresponding OS mark
function get_os_mark() {
  case "$(uname)" in
    Darwin)
      echo -n "\ue351"  # Apple Logo
      ;;
    Linux)
      if [[ -f /etc/arch-release ]]; then
        echo -n "\ue705"  # Arch Logo
      elif [[ -f /etc/manjaro-release ]]; then
        echo -n "\ue738"  # Manjaro Logo
      elif [[ -f /etc/lsb-release && "$(grep DISTRIB_ID /etc/lsb-release | cut -d= -f2)" = "Ubuntu" ]]; then
        echo -n "\ue712"  # Ubuntu Logo
      else
        echo -n ""  # Not supported
      fi
      ;;
    CYGWIN*|MINGW32*|MSYS*)
      echo -n "\ue70f"  # Windows Logo
      ;;
    *)
      echo -n ""  # Not supported
      ;;
  esac
}

PROMPT=`left_prompt`