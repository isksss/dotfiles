#!/bin/sh
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

app_exists(){
    local app_name="$1"
    if command -v "$app_name" >/dev/null 2>&1; then
        printf ">>> ${GREEN}INSTALLED${NC}: ${app_name}\n"
        return 0
    else
        printf ">>> ${RED}NOT INSTALLED${NC}: ${app_name}\n"
        printf ">>> ${YELLOW}INSTALL START${NC}: ${app_name}...\n"
        return 1
    fi
}

printf "###############################\n"
printf "#   ${YELLOW}non package manager app${NC}   #\n"
printf "###############################\n"
############################################################
# volta
# https://volta.sh
############################################################
if ! app_exists "volta"; then
    curl https://get.volta.sh | bash
fi
