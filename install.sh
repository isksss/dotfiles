#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${DOTFILES_REPO_URL:-https://github.com/isksss/dotfiles.git}"
REPO_DIR="${HOME}/dotfiles"
MISE_BIN="${HOME}/.local/bin/mise"

require_cmd() {
	if ! command -v "$1" >/dev/null 2>&1; then
		echo "$1 is required" >&2
		exit 1
	fi
}

require_cmd git
require_cmd curl

if [[ -d "${REPO_DIR}/.git" ]]; then
	echo "Using existing repository: ${REPO_DIR}"
elif [[ -e "${REPO_DIR}" ]]; then
	echo "Path already exists and is not a git repository: ${REPO_DIR}" >&2
	exit 1
else
	echo "Cloning dotfiles repository into ${REPO_DIR}"
	git clone "${REPO_URL}" "${REPO_DIR}"
fi

if ! command -v mise >/dev/null 2>&1; then
	echo "Installing mise"
	curl -fsSL https://mise.run | sh
fi

export PATH="${HOME}/.local/bin:${PATH}"

if ! command -v mise >/dev/null 2>&1 && [[ -x "${MISE_BIN}" ]]; then
	export PATH="$(dirname "${MISE_BIN}"):${PATH}"
fi

require_cmd mise

echo "Installing tools with mise"
mise i -C "${REPO_DIR}"

echo "Linking dotfiles"
mise exec -C "${REPO_DIR}" -- dotfiles link
