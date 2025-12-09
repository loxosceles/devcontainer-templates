ARG VARIANT=1-bookworm
FROM mcr.microsoft.com/devcontainers/python:${VARIANT}

LABEL dev.containers.features="python"

WORKDIR /home/vscode

COPY post_create.sh chezmoi.toml /usr/src/
RUN chmod +x /usr/src/post_create.sh

# Install minimal tools
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    neovim ranger tmux direnv \
    && apt-get clean

# Install uv and ruff system-wide
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    mv /root/.local/bin/uv /usr/local/bin/uv

RUN curl -LsSf https://astral.sh/ruff/install.sh | sh && \
    mv /root/.local/bin/ruff /usr/local/bin/ruff

# Install Python packages with uv
COPY requirements.txt /usr/src/
RUN uv pip install --system --break-system-packages -r /usr/src/requirements.txt

# Set zsh as default shell for vscode user (zsh already installed in base image)
RUN chsh -s /usr/bin/zsh vscode

# Install chezmoi
RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin
