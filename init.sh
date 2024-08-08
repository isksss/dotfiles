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

export GOROOT=$SCRIPT_DIR/.dotfiles/tmp/go
export GOPATH=$XDG_DATA_HOME/go
export GOBIN=$GOPATH/bin

export WORKSPACE="$HOME/workspace"

export PATH="$GOBIN:$GOROOT/bin:$PATH"

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

# go
if !(type "go" > /dev/null 2>&1); then
    echo "=====: warn :====="
    echo "go is not installed."
    echo "download go."
    echo ""
    rm -rf ./go
    # TODO: アップデートが来たら変更する
    go_version="1.22.6"
    target="${os}-${arch}"
    if [ $os = "windows" ]; then
        ext="zip"
    else
        ext="tar.gz"
    fi
    echo "# download"
    go_uri="https://go.dev/dl/go${go_version}.${target}.${ext}"
    curl -fsSL -o "./go.${ext}" $go_uri
    echo "# extract"
    if [ $ext = "zip" ]; then
        unzip -d "./" -o "./go.zip" >/dev/null 2>&1
    else
        tar -zxvf "./go.tar.gz" >/dev/null 2>&1
    fi

    mkdir -p "$SCRIPT_DIR/.dotfiles/tmp"
    mv "./go" "$SCRIPT_DIR/.dotfiles/tmp/go"

    rm -rf "go.${ext}"
fi

# dotfiles
if !(type "dotfiles" > /dev/null 2>&1); then
    echo "=====: warn :====="
    echo "dotfiles is not installed."
    echo "download dotfiles"
    echo ""
    echo "# install dotfiles"
    go install github.com/rhysd/dotfiles@latest
    dotfiles version
fi

# aqua
if !(type "aqua" > /dev/null 2>&1); then
    echo "=====: warn :====="
    echo "aqua is not installed."
    echo "download aqua"
    echo ""
    echo "# install aqua"
    go install github.com/aquaproj/aqua/cmd/aqua@latest
    aqua --version
fi

dotfiles link

aqua i -a
