function update_zellij_tab_name() {
	[[ -n "$ZELLIJ" ]] || return

	local repo branch
	repo=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
	repo="${repo%%=*}"
	branch=$(git branch --show-current 2>/dev/null)

	if [[ -n "$branch" ]]; then
		command nohup zellij action rename-tab "$repo:$branch" >/dev/null 2>&1
	else
		command nohup zellij action rename-tab "$(basename "$PWD")" >/dev/null 2>&1
	fi
}

add-zsh-hook chpwd update_zellij_tab_name

update_zellij_tab_name
