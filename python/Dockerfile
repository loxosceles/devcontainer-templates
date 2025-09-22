ARG VARIANT=1-bookworm
FROM mcr.microsoft.com/devcontainers/python:${VARIANT}

LABEL dev.containers.features="python"

WORKDIR /home/vscode

COPY post_create.sh chezmoi.toml /usr/src/
RUN chmod +x /usr/src/post_create.sh

# Install additional tools (curl and gnupg already included in base image)
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    neovim ranger tmux direnv ipython3 \
    && apt-get clean

# Set zsh as default shell for vscode user (zsh already installed in base image)
RUN chsh -s /usr/bin/zsh vscode

# Install chezmoi
RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin

COPY requirements.txt /usr/src/
RUN pip install -r /usr/src/requirements.txt