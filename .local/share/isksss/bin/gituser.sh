#!/usr/bin/env bash
#------------------------------------------------------------
# git userをisksssに変更する
#------------------------------------------------------------
GIT_USER=$1

if [ "$GIT_USER" = "" ]; then
    echo "If you want to change a git username and email, input git username. ex) isksss"
    echo "current git username: $(git config --get user.name)"
    echo "current git useremail: $(git config --get user.email)"
    exit 0
fi

if [ "$GIT_USER" = "isksss" ]; then
    git config --local user.name isksss
    git config --local user.email 104404522+isksss@users.noreply.github.com
fi

git config --get user.name
git config --get user.email
