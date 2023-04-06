#!/usr/bin/env bash
#----- ----- ----- ----- -----
# Colors
#----- ----- ----- ----- -----
# color code
export RED="\e[31m"
export GREEN="\e[32m"
export YELLOW="\e[33m"
export BLUE="\e[34m"
export MAGENTA="\e[35m"
export CYAN="\e[36m"
export WHITE="\e[37m"
export BOLD="\e[1m"
export UNDERLINE="\e[4m"

# reset color code
export RESET="\e[0m"

# echo info message
function info() {
    echo -e "${GREEN}[INFO]${RESET} $1"
}

# echo error message
function error() {
    echo -e "${RED}[ERROR]${RESET} $1"
}

# echo warning message
function warning() {
    echo -e "${YELLOW}[WARNING]${RESET} $1"
}
