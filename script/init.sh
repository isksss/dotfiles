#!/bin/bash
#var
XDG_CONFIG_HOME=${HOME}/.config
XDG_CACHE_HOME=${HOME}/.cache
XDG_DATA_HOME=${HOME}/.local/share
WORKSPACE=${HOME}/workspace
#fn
function init(){
    local dot_dir=$1
    local current_dir=$(pwd)
    echo "dotfiles_dir: $dot_dir"
    echo "current_dir: $current_dir"
    # create .memo.txt
    touch $dot_dir/.memo.txt

    # create xdg_dir
    mkdir -p $XDG_CACHE_HOME
    mkdir -p $XDG_CONFIG_HOME
    mkdir -p $XDG_DATA_HOME

    # create workspace
    mkdir -p $WORKSPACE

    # link
    ## home
    cd $dot_dir/home
    for config_file in .[^.]*; do
        echo "create symlink: home/$config_file"
        ln -sf "$config_file" "$HOME/$config_file"
    done

    ## .config
    cd $dot_dir/.config
    for config_file in *; do
        echo "create symlink: .config/$config_file"
        ln -sf "$dot_dir/$config_file" "$XDG_CONFIG_HOME/$config_file"
    done
    cd $current_dir

    # rm link
    find $dot_dir -type l -exec rm {} \;
}



init $1