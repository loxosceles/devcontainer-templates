ARG VARIANT=22-bookworm
FROM mcr.microsoft.com/devcontainers/typescript-node:${VARIANT}

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    neovim ranger tmux direnv zsh unzip \
    && curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o /tmp/awscliv2.zip \
    && unzip -q /tmp/awscliv2.zip -d /tmp && /tmp/aws/install && rm -rf /tmp/aws /tmp/awscliv2.zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && usermod -s /usr/bin/zsh node

COPY --chown=node:node post_create.sh /usr/src/
RUN chmod +x /usr/src/post_create.sh
