ARG VARIANT=22-bookworm
FROM node:${VARIANT}

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y install --no-install-recommends \
    neovim ranger tmux direnv zsh \
    docker.io curl unzip fzf less && \
    apt-get clean

# AWS CLI
RUN ARCH=$(uname -m) && \
    curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}.zip" -o /tmp/awscliv2.zip && \
    unzip -q /tmp/awscliv2.zip -d /tmp && /tmp/aws/install && rm -rf /tmp/aws /tmp/awscliv2.zip

RUN usermod -l vscode -d /home/vscode -m node && \
    groupmod -n vscode node && \
    usermod -s /usr/bin/zsh vscode

RUN corepack enable && corepack prepare pnpm@latest --activate

ENV PNPM_HOME="/home/vscode/.local/share/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
ENV ZDOTDIR=/home/vscode/.config/zsh

RUN mkdir -p /home/vscode/.local/share/pnpm && \
    chown -R vscode:vscode /home/vscode/.local

RUN pnpm add -g prettier@^3 typescript@^5

COPY post_create.sh /usr/src/
RUN chmod +x /usr/src/post_create.sh
