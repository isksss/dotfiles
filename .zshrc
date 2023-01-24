# zshrc

#########################
# alias 
#########################

# ls
alias la='ls -a'
alias ll='ls -al'

# git
alias g='git'
alias gs='git status'
alias gcm='git commit -m'
alias gl='git log'

# docker
alias d='docker'
alias dc='docker compose'

# zsh
alias zs='source ~/.zshrc'

# PATH
## for all OS
export PATH="$PATH:$HOME/dotfiles/.bin"
## for MacOS
if [ "$(uname)" == "Darwin" ] ; then
	echo "macOS!"

    #fnm
	export PATH="$HOME/Library/Application Support/fnm:$PATH"
    eval "`fnm env`"
fi