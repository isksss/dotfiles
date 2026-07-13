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

backup_conflicts() {
	status_file="$(mktemp)"
	trap 'rm -f "$status_file"' EXIT HUP INT TERM

	"$MISE_BIN" dotfiles status --json >"$status_file" || true
	if "$MISE_BIN" exec -- jq -e '.files[] | select(.state == "source_missing")' "$status_file" >/dev/null; then
		"$MISE_BIN" exec -- jq -r '.files[] | select(.state == "source_missing") | "missing source: \(.target)"' "$status_file" >&2
		die "dotfile source is missing."
	fi

	backup_root="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles-backups/$(date '+%Y%m%d-%H%M%S')"
	conflicts=$("$MISE_BIN" exec -- jq -r '.files[] | select(.state == "differs") | .target' "$status_file")
	[ -n "$conflicts" ] || return 0

	log "Backing up conflicting dotfiles to $backup_root..."
	printf '%s\n' "$conflicts" | while IFS= read -r target; do
		[ -n "$target" ] || continue
		case "$target" in
		"~/"*) target="$HOME/${target#\~/}" ;;
		esac
		backup_target=$target
		candidate=$target
		while [ "$candidate" != "$HOME" ]; do
			if [ -L "$candidate" ]; then
				backup_target=$candidate
			fi
			candidate=$(dirname "$candidate")
		done
		target=$backup_target
		if [ ! -e "$target" ] && [ ! -L "$target" ]; then
			continue
		fi
		case "$target" in
		"$HOME"/*) relative=${target#"$HOME"/} ;;
		*) die "refusing to back up target outside HOME: $target" ;;
		esac
		destination="$backup_root/$relative"
		mkdir -p "$(dirname "$destination")"
		mv "$target" "$destination"
	done
}

main() {
	require_command git
	install_mise
	checkout_repository

	cd "$DOTFILES_DIR"
	log "Trusting mise config..."
	"$MISE_BIN" trust "$DOTFILES_DIR/mise.toml"

	log "Installing bootstrap dependencies..."
	"$MISE_BIN" install jq

	log "Previewing dotfile changes..."
	"$MISE_BIN" dotfiles apply --dry-run --verbose --force
	backup_conflicts

	log "Applying dotfiles and installing tools..."
	"$MISE_BIN" bootstrap --yes --force-dotfiles

	log "Bootstrap complete: $DOTFILES_DIR"
}

main "$@"
