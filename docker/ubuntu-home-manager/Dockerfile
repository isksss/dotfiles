FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    xz-utils \
    sudo \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash tester && \
    echo "tester ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/tester

USER tester
WORKDIR /workspace/dotfiles

RUN sh <(curl -L https://nixos.org/nix/install) --no-daemon && \
    mkdir -p /home/tester/.config/nix && \
    printf 'experimental-features = nix-command flakes\n' > /home/tester/.config/nix/nix.conf

ENV PATH="/home/tester/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"

CMD ["bash"]
