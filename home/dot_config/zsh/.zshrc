# zsh
ZSH_COMPDUMP="${XDG_CACHE_HOME}/zsh/.zcompdump"

# ==========
# local

if [[ -f "$ZDOTDIR/local.zsh" ]]; then
	. "$ZDOTDIR/local.zsh"
else
	touch "$ZDOTDIR/local.zsh"
fi
alias editlocal="nvim $ZDOTDIR/local.zsh"

# ==========
# zshオプション
autoload -Uz add-zsh-hook
autoload -Uz compinit
compinit

HISTFILE="${XDG_CACHE_HOME}/zsh/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt inc_append_history   # 実行ごとに即書き込み
setopt share_history        # 全セッションで共有
setopt hist_ignore_all_dups # 重複を即削除
setopt hist_reduce_blanks   # 余分な空白を削除
setopt hist_verify          # 実行前に確認
setopt extended_history     # タイムスタンプ付き
setopt NO_BEEP              # 音が鳴らないようにする
# ==========
# lang

# rust
if [[ -f "$HOME/.cargo/env" ]]; then
	. "$HOME/.cargo/env"
fi

# ==========
# alias
alias re="exec ${SHELL} -l"
alias cdrepo='cd "$(ghq list -p | fzf)"'

# ssh
if [[ -r /proc/sys/kernel/osrelease ]] && grep -qi microsoft /proc/sys/kernel/osrelease && command -v ssh.exe >/dev/null 2>&1; then
	alias ssh="ssh.exe"
fi

# mise
if command -v mise >/dev/null 2>&1; then
	eval "$(mise activate zsh)"
	eval "$(mise completion zsh)"

	alias mx="mise x --"
fi

# zoxide
if command -v zoxide >/dev/null 2>&1; then
	eval "$(zoxide init zsh --cmd cd)"
fi
alias ..="cd .."

# nvim
if command -v nvim >/dev/null 2>&1; then
	alias vim="nvim"
fi

# ls
if command -v eza >/dev/null 2>&1; then
	alias ls="eza"
fi

if command -v bat >/dev/null 2>&1; then
	alias cat="bat"
fi

# lazygit
if command -v lazygit >/dev/null 2>&1; then
	alias lg="lazygit"
fi

# docker
if command -v docker >/dev/null 2>&1; then
	alias d="docker"
	alias dc="docker compose"
	alias dce="docker compose exec"
	alias dps="docker ps"
	alias di="docker images"
fi

if command -v lazydocker >/dev/null 2>&1; then
	alias ld="lazydocker"
fi

# zellij
if command -v zellij >/dev/null 2>&1; then
	alias zl="zellij"
	zla() {
		local session
		session="$(zellij ls -s | fzf --reverse --height 40%)" || return
		[[ -n "$session" ]] || return 0
		zellij a "$session"
	}
fi

# fzf
if command -v fzf >/dev/null 2>&1; then
	. <(fzf --zsh)
fi

# atuin
if command -v atuin >/dev/null 2>&1; then
	eval "$(atuin init zsh)"
fi

# wtp
if command -v wtp >/dev/null 2>&1; then
	eval "$(wtp completion zsh)"
	eval "$(wtp hook zsh)"
fi

# gh
if command -v gh >/dev/null 2>&1; then
	eval "$(gh completion -s zsh)"
fi

# glab
if command -v glab >/dev/null 2>&1; then
	eval "$(glab completion -s zsh)"
fi

# chezmoi
if command -v chezmoi >/dev/null 2>&1; then
	eval "$(chezmoi completion zsh)"
	# chezmoiの管理下にあるディレクトリに移動する関数
	ccd() {
		local target
		target="$(chezmoi source-path)/.." || return
		[[ -n "$target" ]] || return 0
		cd "$target" || return 1
	}
fi

# fzf+ghq+gwq
if command -v fzf >/dev/null 2>&1 && command -v ghq >/dev/null 2>&1 && command -v gwq >/dev/null 2>&1; then
	# ghqでリポジトリを選択する関数
	function ghq-path() {
		ghq list --full-path | fzf
	}
	# ghqで選択したリポジトリに移動する関数
	function dev() {
		local moveto
		moveto=$(ghq-path)
		[[ -n "$moveto" ]] || return 0
		cd "${moveto}" || return 1
	}
	# マージ済みブランチを削除する関数
	function gwq-clean-merged() {
		local current
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
	eval "$(gwq completion zsh)"
fi

# ZDOTDIR以下のscriptsディレクトリにある.zshファイルを全て読み込む
if [[ -d "$ZDOTDIR/scripts" ]]; then
	for script in "$ZDOTDIR"/scripts/*.zsh; do
		[[ -f "$script" ]] && . "$script"
	done
fi
