##################################################
# DOTFILES MAKEFILE
##################################################
DOTFILES ?= $(CURDIR)
OS ?= $(shell uname -s)
# XDG
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_CACHE_HOME ?= $(HOME)/.cache
XDG_DATA_HOME ?= $(HOME)/.local/share
XDG_STATE_HOME ?= $(HOME)/.local/state
# MY_DIR
WORKSPACE ?= $(HOME)/workspace
LOCAL_BIN ?= $(HOME)/.local/bin
MAC_CODE_DIR ?= "$(HOME)/Library/Application Support/Code/User"
# DOTFILES_URL
REMOTE_URL ?= https://github.com/isksss/dotfiles.git
GIT_URL ?= git@github.com:isksss/dotfiles.git

##################################################
# Make
##################################################

.PHONY: all
all:
	@echo "##### Dotfiles Makefile #####"
	@$(MAKE) init
	@$(MAKE) createDir
	@$(MAKE) symlink

.PHONY: createDir
createDir:
	@echo "#     CREATE DIRECTORY"
	@mkdir -p $(XDG_CONFIG_HOME) $(XDG_CACHE_HOME) $(XDG_DATA_HOME) $(XDG_STATE_HOME)
	@mkdir -p $(WORKSPACE) $(LOCAL_BIN)
	@mkdir -p $(MAC_CODE_DIR)
	@mkdir -p $(XDG_CONFIG_HOME)/Code/User

.PHONY: symlink
symlink:
	@echo "#     CREATE SYMLINK"
	@ln -sf $(DOTFILES)/config/zsh $(XDG_CONFIG_HOME)/zsh
	@ln -sf $(DOTFILES)/config/zsh/.zshenv $(HOME)/.zshenv
	@ln -sf $(DOTFILES)/config/nvim $(XDG_CONFIG_HOME)/nvim
	@ln -sf $(DOTFILES)/config/git $(XDG_CONFIG_HOME)/git
	@ln -sf $(DOTFILES)/config/tmux $(XDG_CONFIG_HOME)/tmux
	@ln -sf $(DOTFILES)/config/alacritty $(XDG_CONFIG_HOME)/alacritty
	@ln -sf $(DOTFILES)/bin $(LOCAL_BIN)
	@ln -sf $(DOTFILES)/config/Code/User/settings.json $(MAC_CODE_DIR)/settings.json
	@ln -sf $(DOTFILES)/config/Code/User/keybindings.json $(MAC_CODE_DIR)/keybindings.json
	@ln -sf $(DOTFILES)/config/Code/User/settings.json $(XDG_CONFIG_HOME)/Code/User/settings.json
	@ln -sf $(DOTFILES)/config/Code/User/keybindings.json $(XDG_CONFIG_HOME)/Code/User/keybindings.json
	@ln -sf $(DOTFILES)/config/fctix5/.xprofile $(HOME)/.xprofile
	@ln -sf $(DOTFILES)/config/starship $(XDG_CONFIG_HOME)/starship
	@$(MAKE) dellink

.PHONY: dellink
dellink:
	@echo "#     DELETE SYMBOLIC LINK"
	@chmod +x $(DOTFILES)/script/dellink.sh
	@$(DOTFILES)/script/dellink.sh $(DOTFILES)

.PHONY: init
init:
	@echo $(DOTFILES) > $(HOME)/.dotfiles-path
	@echo "#     DOTFILES PATH = $(DOTFILES)"
	@$(MAKE) git-remote
	@chsh -s $(shell which zsh)

.PHONY: git-remote
git-remote:
	git remote set-url origin $(GIT_URL) >/dev/null 2>&1

.PHONY: install
install:
	@chmod +x $(DOTFILES)/script/*
	@$(DOTFILES)/script/volta_install.sh