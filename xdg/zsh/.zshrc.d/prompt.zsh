# zsh prpmpt
## LEFT
function left_prompt(){
    # variables
    local user=$USER
    
    # color
    local green="%{$fg[green]%}"
    local yellow="%{$fg[yellow]%}"
    local blue="%{$fg[blue]%}"
    local red="%{$fg[red]%}"
    local white="%{$fg[white]%}"
    local reset="%{$reset_color%}"

    # icon
    local icon_arrow="\ue0b0"
    local icon_arch="\uf303"
    local icon_manjaro="\uf312"
    local icon_git_branch="\ue0a0"

    echo $icon_arrow
}

PROMPT=`left_prompt`