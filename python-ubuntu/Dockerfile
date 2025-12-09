ARG VARIANT=ubuntu-24.04
FROM mcr.microsoft.com/devcontainers/base:${VARIANT}

LABEL dev.containers.features="python"

WORKDIR /home/vscode

COPY post_create.sh chezmoi.toml /usr/src/
RUN chmod +x /usr/src/post_create.sh

# Install development tools
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    git pip libzip-dev unzip ranger gnupg curl direnv neovim tmux \
    && apt-get clean

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

# Install ruff
RUN curl -LsSf https://astral.sh/ruff/install.sh | sh

# Install Python packages with uv
COPY requirements.txt /usr/src/
RUN /bin/bash -c "source $HOME/.local/bin/env && uv pip install --system --break-system-packages -r /usr/src/requirements.txt"

# Set zsh as default shell for vscode user (zsh already installed in base image)
RUN chsh -s /usr/bin/zsh vscode

# Install chezmoi
RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin
