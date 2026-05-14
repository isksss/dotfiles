# chpwd時にgit repository内だった場合、そのリポジトリルートに存在する.envファイルを読み込む
autoload -Uz add-zsh-hook
function load_env_from_git_root() {
	local git_root
	git_root=$(git rev-parse --show-toplevel 2>/dev/null) || return

	local env_file="$git_root/.env"
	if [[ -f "$env_file" ]]; then
		# .envファイルを読み込む
		source "$env_file"
	fi
}
add-zsh-hook chpwd load_env_from_git_root
load_env_from_git_root
