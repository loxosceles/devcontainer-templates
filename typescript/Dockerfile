ARG VARIANT=22-bookworm
FROM mcr.microsoft.com/devcontainers/typescript-node:${VARIANT}

LABEL dev.containers.features="typescript"

WORKDIR /home/vscode

COPY post_create.sh chezmoi.toml /usr/src/
RUN chmod +x /usr/src/post_create.sh

# Install specific tools
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    neovim ranger tmux direnv ipython3 \
    && apt-get clean

# Set zsh as default shell for vscode user (zsh already installed in base image)
RUN chsh -s /usr/bin/zsh vscode

COPY package*.json tsconfig.json ./
RUN npm install

# Install chezmoi
RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin

# Add node_modules/.bin to PATH
ENV PATH=/home/vscode/node_modules/.bin:$PATH