#!/bin/bash
#############################################################
# dotfiles
# require: git curl unixlike:tar windows:unzip
#############################################################
cd $(dirname $0)
#==============================
# 環境変数
#==============================
SCRIPT_DIR=$(
    cd $(dirname $0)
    pwd
)

export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache
export XDG_STATE_HOME=$HOME/.local/state
export WORKSPACE="$HOME/workspace"

export AQUA_ROOT_DIR="$XDG_DATA_HOME/aqua"

export PATH="$SCRIPT_DIR/.local/bin:$AQUA_ROOT_DIR/bin:$PATH"

export DOTFILES_REPO_PATH=$SCRIPT_DIR

case "$(uname -s)" in
Linux*) os=linux ;;
Darwin*) os=darwin ;;
CYGWIN*) os=windows ;;
MINGW*) os=windows ;;
MSYS*) os=windows ;;
*) echo "not supported os." && exit 1 ;;
esac

case "$(uname -m)" in
x86_64*) arch=amd64 ;;
# TODO: arm64
*) echo "not supported arch." && exit 1 ;;
esac

#==============================
# ディレクトリ作成
#==============================
mkdir -p \
    $XDG_CONFIG_HOME $XDG_DATA_HOME $XDG_CACHE_HOME $XDG_STATE_HOME $WORKSPACE
#==============================
# 関数
#==============================

#==============================
# 依存確認
#==============================
# git
if !(type "git" > /dev/null 2>&1); then
    echo "=====: warn :====="
    echo "git is not installed."
    exit 1
fi

# aqua
if !(type "aqua" > /dev/null 2>&1); then
    echo "=====: warn :====="
    echo "aqua is not installed."
    echo "download aqua"
    echo ""

    if [ $os = "windows"] && !(type "unzip" > /dev/null 2>&1); then
        echo "unzip is not installed."
        exit 1
    elif !(type "tar" > /dev/null 2>&1); then
        echo "unzip is not installed."
        exit 1
    fi

    echo "# install aqua"
    target="${os}_${arch}"
    if [ $os = "windows" ]; then
        ext="zip"
    else
        ext="tar.gz"
    fi
    aqua_uri="https://github.com/aquaproj/aqua/releases/latest/download/aqua_${target}.${ext}"
    echo $aqua_uri
    curl -fsSL -o "./aqua.${ext}" $aqua_uri
    echo "# extract"
    if [ $ext = "zip" ]; then
        unzip -d "./" -o "./aqua.zip" >/dev/null 2>&1
        mv "./aqua.exe" "./.local/bin/"
    else
        tar -zxvf "./aqua.tar.gz" >/dev/null 2>&1
        mv "./aqua" "./.local/bin/"
    fi
    rm -rf "aqua.${ext}"
fi
which aqua
aqua i
dotfiles link
