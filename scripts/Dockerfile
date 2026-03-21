FROM archlinux:latest

# 基本パッケージ
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
        sudo git curl base-devel openssh zsh



# 引数
ARG USERNAME=dev
ARG UID=1000
ARG GID=1000

# ユーザー作成
RUN groupadd -g $GID $USERNAME && \
    useradd -m -u $UID -g $GID -s /bin/zsh $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER $USERNAME
WORKDIR /home/$USERNAME

# PATH
ENV PATH="/home/$USERNAME/.local/bin:$PATH"

# --- yayインストール ---
RUN git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg -si --noconfirm && \
    cd ~ && \
    rm -rf yay

# mise
RUN curl https://mise.run | sh
