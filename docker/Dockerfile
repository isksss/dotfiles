# test container
FROM --platform=arm64 ubuntu:22.04

ARG UID
ARG GID
ARG USERNAME
ARG PASSWORD

RUN apt update && apt install -y sudo

RUN groupadd -g $GID $USERNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID -G sudo $USERNAME && \
    echo $USERNAME:$PASSWORD | chpasswd && \
    echo "$USERNAME   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $USERNAME
WORKDIR /home/$USERNAME/