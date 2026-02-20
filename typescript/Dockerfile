ARG VARIANT=22-bookworm
FROM mcr.microsoft.com/devcontainers/typescript-node:${VARIANT}

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    neovim ranger tmux direnv zsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --chown=node:node post_create.sh /usr/src/
RUN chmod +x /usr/src/post_create.sh
