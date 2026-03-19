FROM archlinux:latest

# 基本パッケージ
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
        sudo git curl base-devel openssh zsh neovim

# mise
RUN curl https://mise.run | sh

# ユーザ作成
ARG USERNAME=dev
ARG UID=1000
ARG GID=1000

RUN groupadd -g $GID $USERNAME && \
    useradd -m -u $UID -g $GID -s /bin/zsh $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER $USERNAME
WORKDIR /home/$USERNAME

# PATH
ENV PATH="/home/$USERNAME/.local/bin:$PATH"