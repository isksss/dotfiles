function init_local_settings() {
	local git_root
	git_root=$(git rev-parse --show-toplevel 2>/dev/null) || {
		echo "not in a git repository"
		return 1
	}

	local agents_file="$git_root/AGENTS.local.md"
	local mise_file="$git_root/mise.local.toml"

	if [[ -e "$agents_file" ]]; then
		echo "exists: $agents_file"
	else
		{
			echo "# AGENTS.local.md"
			echo
			echo "このリポジトリ固有のエージェント向けローカル指示を記載する。"
		} >"$agents_file"
		echo "created: $agents_file"
	fi

	if [[ -e "$mise_file" ]]; then
		echo "exists: $mise_file"
	else
		{
			echo "# リポジトリ固有の mise 設定を記載する。"
		} >"$mise_file"
		echo "created: $mise_file"
	fi
}
