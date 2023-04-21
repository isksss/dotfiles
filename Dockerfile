## Arch
FROM archlinux:base

RUN pacman -Syu --noconfirm --needed \
    git \
    zsh \
    sudo \
    make \
    neovim \
    && rm -rf /var/cache/pacman/pkg/* \
    && useradd -m -g users -G wheel -s /bin/zsh isksss \
    && echo -e "1234\n1234\n" | passwd isksss \
    && echo -e "1234\n1234\n" | passwd root \
    && echo "isksss ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /home/isksss
USER isksss

RUN git clone https://github.com/isksss/dotfiles.git ~/dotfiles \
    && cd ~/dotfiles \
    && make install
