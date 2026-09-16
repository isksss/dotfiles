#!/usr/bin/env bash
set -euo pipefail

context=${HERDR_PLUGIN_CONTEXT_JSON:-}
repo_cwd=$(jq -r '(.workspace_cwd // .focused_pane_cwd) // empty' <<<"$context")
if [[ -z "$repo_cwd" || ! -d "$repo_cwd" ]]; then
	printf 'Herdr workspace directory is unavailable.\n' >&2
	exit 1
fi

exec "${HERDR_BIN_PATH:-herdr}" plugin pane open \
	--plugin "${HERDR_PLUGIN_ID:?}" \
	--entrypoint create \
	--focus
