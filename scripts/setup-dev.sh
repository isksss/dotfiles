#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMAGE_NAME=arch-dev-env
CONTAINER_NAME=arch-dev-container
USER_ID=$(id -u)
GROUP_ID=$(id -g)

# 初回のみbuild
if [[ "$(docker images -q $IMAGE_NAME 2>/dev/null)" == "" ]]; then
	docker build \
		-f "$SCRIPT_DIR/Dockerfile" \
		--build-arg UID=$USER_ID \
		--build-arg GID=$GROUP_ID \
		-t $IMAGE_NAME "$SCRIPT_DIR"
fi

docker run -it --rm \
	--name $CONTAINER_NAME \
	-v $HOME/.ssh:/home/dev/.ssh:ro \
	-v $HOME/.gitconfig:/home/dev/.gitconfig:ro \
	-v $HOME/dotfiles:/home/dev \
	-v $HOME/work:/home/dev/work \
	-v mise-cache:/home/dev/.local/share/mise \
	-w /home/dev/work \
	$IMAGE_NAME \
	zsh
