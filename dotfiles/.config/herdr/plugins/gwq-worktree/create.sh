#!/usr/bin/env bash
set -euo pipefail

context=${HERDR_PLUGIN_CONTEXT_JSON:-}
repo_cwd=$(jq -r '(.workspace_cwd // .focused_pane_cwd) // empty' <<<"$context")
if [[ -z "$repo_cwd" || ! -d "$repo_cwd" ]]; then
	printf 'Herdr workspace directory is unavailable.\n' >&2
	exit 1
fi

cd "$repo_cwd"

mapfile -t before < <(git worktree list --porcelain | awk '$1 == "worktree" { print substr($0, 10) }')

printf '1) Select an existing branch\n2) Create a new branch\n\nChoice [1]: '
read -r choice
choice=${choice:-1}
case "$choice" in
1)
	gwq add -i
	;;
2)
	printf 'Branch name: '
	read -r branch
	[[ -n "$branch" ]] || exit 1
	gwq add -b "$branch"
	;;
*)
	printf 'Invalid choice.\n' >&2
	exit 1
	;;
esac

mapfile -t after < <(git worktree list --porcelain | awk '$1 == "worktree" { print substr($0, 10) }')
new_path=''
for path in "${after[@]}"; do
	if ! printf '%s\n' "${before[@]}" | grep -Fqx -- "$path"; then
		new_path=$path
		break
	fi
done

if [[ -z "$new_path" ]]; then
	printf 'Could not determine the created worktree path.\n' >&2
	exit 1
fi

"${HERDR_BIN_PATH:-herdr}" worktree open \
	--cwd "$repo_cwd" \
	--path "$new_path" \
	--focus
