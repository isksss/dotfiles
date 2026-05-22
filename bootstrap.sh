#!/usr/bin/env sh
set -eu

REPO_URL="${DOTFILES_REPO_URL:-https://github.com/isksss/dotfiles.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
MISE_BIN="${MISE_BIN:-}"

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

find_mise() {
	if [ -n "$MISE_BIN" ] && [ -x "$MISE_BIN" ]; then
		add_mise_to_path
		return 0
	fi

	if command -v mise >/dev/null 2>&1; then
		MISE_BIN="$(command -v mise)"
		add_mise_to_path
		return 0
	fi

	if [ -x "$HOME/.local/bin/mise" ]; then
		MISE_BIN="$HOME/.local/bin/mise"
		add_mise_to_path
		return 0
	fi

	return 1
}

add_mise_to_path() {
	mise_dir="$(dirname "$MISE_BIN")"
	case ":$PATH:" in
	*":$mise_dir:"*) ;;
	*) PATH="$mise_dir:$PATH" ;;
	esac
	export PATH
}

install_mise() {
	find_mise && return 0

	require_command curl
	log "Installing mise..."
	curl https://mise.run | sh
	find_mise || die "mise was installed but could not be found. Check ~/.local/bin/mise."
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

	parent_dir="$(dirname "$DOTFILES_DIR")"
	mkdir -p "$parent_dir"
	log "Cloning $REPO_URL into $DOTFILES_DIR..."
	git clone "$REPO_URL" "$DOTFILES_DIR"
}

run_dotfiles() {
	"$MISE_BIN" exec go@latest go:github.com/rhysd/dotfiles@latest -- dotfiles "$@"
}

main() {
	require_command git
	install_mise
	checkout_repository

	cd "$DOTFILES_DIR"
	log "Trusting mise config..."
	"$MISE_BIN" trust "$DOTFILES_DIR/mise.toml"

	log "Previewing dotfile links..."
	run_dotfiles link --dry

	log "Linking dotfiles..."
	run_dotfiles link

	log "Installing tools from mise.toml..."
	"$MISE_BIN" install

	log "Bootstrap complete: $DOTFILES_DIR"
}

main "$@"
