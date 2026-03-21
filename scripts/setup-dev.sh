#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMAGE_NAME=arch-dev-env
CONTAINER_NAME=arch-dev-container
USER_ID=$(id -u)
GROUP_ID=$(id -g)

# --- 引数解析 ---
REBUILD=false

for arg in "$@"; do
	case $arg in
	--rebuild)
		REBUILD=true
		shift
		;;
	esac
done

# --- build判定 ---
if $REBUILD; then
	echo "🔁 Rebuilding Docker image..."
	docker build \
		--no-cache \
		-f "$SCRIPT_DIR/Dockerfile" \
		--build-arg UID=$USER_ID \
		--build-arg GID=$GROUP_ID \
		-t $IMAGE_NAME \
		"$SCRIPT_DIR"
else
	if [[ "$(docker images -q $IMAGE_NAME 2>/dev/null)" == "" ]]; then
		echo "📦 Building Docker image (first time)..."
		docker build \
			-f "$SCRIPT_DIR/Dockerfile" \
			--build-arg UID=$USER_ID \
			--build-arg GID=$GROUP_ID \
			-t $IMAGE_NAME \
			"$SCRIPT_DIR"
	else
		echo "⚡ Using existing image"
	fi
fi

docker run -it --rm \
	--name $CONTAINER_NAME \
	-v $HOME/.ssh:/home/dev/.ssh:ro \
	-v $HOME/.gitconfig:/home/dev/.gitconfig:ro \
	-v $HOME/dotfiles:/home/dev/dotfiles \
	-v $HOME/work:/home/dev/work \
	-v mise-cache:/home/dev/.local/share/mise \
	-w /home/dev/work \
	$IMAGE_NAME \
	zsh
