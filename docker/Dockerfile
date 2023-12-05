FROM archlinux:base-devel

# env
ENV TZ=Asia/Tokyo
ENV LANG=ja_JP.UTF-8

ARG USER_NAME
ARG USER_ID

# Create user
RUN pacman -Syu --noconfirm \
    git \
    cmake \
    make \
    sudo \
    zsh \
    neovim && \
    useradd -m ${USER_NAME} -u ${USER_ID}  -s /usr/bin/zsh && \
    echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/${USER_NAME} && \
    chmod 0440 /etc/sudoers.d/${USER_NAME}

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}

# install dotfiles
RUN git clone --depth 1 https://github.com/isksss/dotfiles.git && \
    cd dotfiles && \
    make arch-install

CMD [ "/usr/bin/zsh" ]