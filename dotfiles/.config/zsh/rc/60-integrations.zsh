# Optional tool and platform integrations.
if [[ -r /proc/sys/kernel/osrelease ]] && grep -qi microsoft /proc/sys/kernel/osrelease && (( $+commands[ssh.exe] )); then
	alias ssh="ssh.exe"
fi

(( $+commands[zoxide] )) && eval "$(zoxide init zsh --cmd cd)"
(( $+commands[fzf] )) && source <(fzf --zsh)
(( $+commands[atuin] )) && eval "$(atuin init zsh)"

if (( $+commands[wtp] )); then
	eval "$(wtp hook zsh)"
fi

if [[ -d "$HOME/.opencode/bin" ]]; then
	path=(${path:#$HOME/.opencode/bin})
	path+=("$HOME/.opencode/bin")
	export PATH
fi

update_zellij_tab_name() {
	[[ -n "$ZELLIJ" ]] || return

	local root branch name
	root=$(git rev-parse --show-toplevel 2>/dev/null)
	branch=$(git branch --show-current 2>/dev/null)
	name=${root:t}
	name=${name%%=*}

	if [[ -n "$root" && -n "$branch" ]]; then
		command nohup zellij action rename-tab "$name:$branch" >/dev/null 2>&1
	else
		command nohup zellij action rename-tab "${PWD:t}" >/dev/null 2>&1
	fi
}

add-zsh-hook chpwd update_zellij_tab_name
update_zellij_tab_name
