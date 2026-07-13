# Interactive helper functions.
if (( $+commands[zellij] )); then
	zla() {
		local session
		session="$(zellij ls -s | fzf --reverse --height 40%)" || return
		[[ -n "$session" ]] || return 0
		zellij attach "$session"
	}

	zlmain() {
		zellij attach --create main
	}
fi

if (( $+commands[fzf] && $+commands[ghq] && $+commands[gwq] )); then
	ghq-path() {
		ghq list --full-path | fzf
	}

	dev() {
		local destination
		destination=$(ghq-path)
		[[ -n "$destination" ]] || return 0
		cd "$destination" || return 1
	}

	gwq-clean-merged() {
		local current branch
		current=$(git branch --show-current)

		git branch --merged |
			sed 's/^[*+] //' |
			grep -v '^main$' |
			grep -v '^master$' |
			grep -v '^develop$' |
			grep -v "^${current}$" |
			while read -r branch; do
				[[ -z "$branch" ]] && continue
				echo "remove $branch"
				gwq remove "$branch"
				git branch -d "$branch"
			done
	}
fi

typeset -g DOTFILES_REPO_PATH="$HOME/dotfiles"
export DOTFILES_REPO_PATH

ccd() {
	cd "$DOTFILES_REPO_PATH" || return 1
}

init_local_settings() {
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
		echo "# リポジトリ固有の mise 設定を記載する。" >"$mise_file"
		echo "created: $mise_file"
	fi
}
