#!/usr/bin/env bash
BASE_MEMO_DIR="${XDG_DATA_HOME:-"$HOME/.local/share"}/.memo"
YEAR=$(date '+%Y')
MONTH=$(date '+%m')
DAY=$(date '+%d')
MEMO_DIR="${BASE_MEMO_DIR}/${YEAR}/${MONTH}"
mkdir -p "$MEMO_DIR"

EDITOR="${EDITOR:-"nvim"}"
YYYYMMDD="$(date '+%Y%m%d')"
MEMO="${MEMO_DIR}/${YYYYMMDD}.md"
if [ ! -e "$MEMO" ]; then
    touch "$MEMO"
    echo "# ${YYYYMMDD}" > "${MEMO}"
fi

$EDITOR $MEMO
