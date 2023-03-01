#!/bin/sh
C_DIR=$(cd $(dirname $0); pwd)
OS=$(uname)

echo "OS:$OS"
if [ $OS = "Linux" ];then
    $C_DIR/linux/_install.sh
fi