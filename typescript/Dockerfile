ARG VARIANT=22-bookworm
FROM mcr.microsoft.com/devcontainers/typescript-node:${VARIANT}

LABEL dev.containers.features="typescript"

# Create vscode user
RUN useradd -m -s /bin/bash vscode \
    && echo vscode ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/vscode \
    && chmod 0440 /etc/sudoers.d/vscode

# Install specific tools
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    neovim ranger tmux direnv ipython3 zsh \
    && apt-get clean

# Set zsh as default shell for vscode user
RUN chsh -s /usr/bin/zsh vscode

# Install chezmoi
RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin

# Switch to vscode user for remaining operations
USER vscode
WORKDIR /home/vscode

# Create config directory and copy files directly to final locations
RUN mkdir -p /home/vscode/.config/chezmoi
COPY --chown=vscode:vscode chezmoi.toml /home/vscode/.config/chezmoi/
COPY --chown=vscode:vscode post_create.sh /usr/src/
COPY --chown=vscode:vscode package*.json tsconfig.json ./

# Make post_create.sh executable
RUN chmod +x /usr/src/post_create.sh

# Install npm packages as vscode user
RUN npm install

# Add node_modules/.bin to PATH
ENV PATH=/home/vscode/node_modules/.bin:$PATH
