# zshrc

# update dotfiles
#dotfiles

#########################
# alias 
#########################

alias cl='clear'

# ls
alias la='ls -a'
alias ll='ls -al'

# git
alias g='git'
alias gs='git status'
alias ga='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gl='git log'
alias gla='git log --oneline --graph'
alias gp='git push'
alias gd='git diff'

# docker
alias d='docker'
alias dc='docker compose'

# zsh
alias zs='source ~/.zshrc'

# nvim
alias n='nvim'

# pyenv virtualenv
alias py='pyenv'
alias pyv='pyenv virtualenv'
alias pyg='pyenv global'

# PATH
## my bin
export PATH="$PATH:$HOME/dotfiles/.bin"
## go bin
export PATH="$PATH:$HOME/go/bin"

## for MacOS
if [ "$(uname)" = "Darwin" ] ; then

	# echo "macOS!"

    #fnm
	export PATH="$HOME/Library/Application Support/fnm:$PATH"
  eval "`fnm env`"

  # pyenv
  export PYENV_ROOT="$HOME/.pyenv"
  command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"

fi
