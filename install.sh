#!/usr/bin/env bash
set -euo pipefail

if ! command -v curl >/dev/null 2>&1; then
	echo "curl が必要です" >&2
	exit 1
fi

if ! command -v mise >/dev/null 2>&1; then
	echo "mise をインストールします"
	curl -fsSL https://mise.run | sh
fi

echo "mise のツールを同期します"
mise install
