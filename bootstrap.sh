#!/usr/bin/env sh
set -eu

REPO_URL="${DOTFILES_REPO_URL:-https://github.com/isksss/dotfiles.git}"
DOTFILES_DIR="$HOME/dotfiles"
MISE_BIN="$HOME/.local/bin/mise"

log() {
	printf '%s\n' "$*"
}

die() {
	printf 'bootstrap: %s\n' "$*" >&2
	exit 1
}

require_command() {
	command -v "$1" >/dev/null 2>&1 || die "'$1' is required."
}

install_mise() {
	if [ -x "$MISE_BIN" ] && "$MISE_BIN" dotfiles --help >/dev/null 2>&1; then
		return
	fi

	require_command curl
	log "Installing mise with the official installer..."
	curl -fsSL https://mise.run | sh
	[ -x "$MISE_BIN" ] || die "mise was not installed at $MISE_BIN."
	"$MISE_BIN" dotfiles --help >/dev/null 2>&1 || die "the installed mise does not support dotfiles."
}

same_repository() {
	remote_url="$(git -C "$DOTFILES_DIR" config --get remote.origin.url 2>/dev/null || true)"
	case "$remote_url" in
	"$REPO_URL" | https://github.com/isksss/dotfiles | git@github.com:isksss/dotfiles.git | ssh://git@github.com/isksss/dotfiles.git)
		return 0
		;;
	esac

	return 1
}

checkout_repository() {
	if [ -e "$DOTFILES_DIR" ]; then
		[ -d "$DOTFILES_DIR/.git" ] || die "$DOTFILES_DIR already exists and is not a Git checkout."
		same_repository || die "$DOTFILES_DIR already exists and origin is not $REPO_URL."
		log "Using existing checkout: $DOTFILES_DIR"
		return
	fi

	log "Cloning $REPO_URL into $DOTFILES_DIR..."
	git clone "$REPO_URL" "$DOTFILES_DIR"
}

main() {
	require_command git
	install_mise
	checkout_repository

	cd "$DOTFILES_DIR"
	log "Trusting mise config..."
	"$MISE_BIN" trust "$DOTFILES_DIR/mise.toml"

	log "Running initialization task..."
	"$MISE_BIN" run --skip-tools init

	log "Bootstrap complete: $DOTFILES_DIR"
}

main "$@"
