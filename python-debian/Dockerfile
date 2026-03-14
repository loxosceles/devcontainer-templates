ARG VARIANT=python3.12-bookworm
FROM ghcr.io/astral-sh/uv:${VARIANT}

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y install --no-install-recommends \
    neovim ranger tmux direnv zsh fzf && \
    apt-get clean

RUN useradd -m -s /usr/bin/zsh -u 1000 vscode

RUN curl -LsSf https://astral.sh/ruff/install.sh | sh && \
    mv /root/.local/bin/ruff /usr/local/bin/ruff

ENV PIPENV_VENV_IN_PROJECT=enabled
ENV PYTHONDONTWRITEBYTECODE=1
ENV ZDOTDIR=/home/vscode/.config/zsh

COPY requirements.txt /tmp/
RUN uv pip install --system --break-system-packages -r /tmp/requirements.txt

COPY post_create.sh /usr/src/
RUN chmod +x /usr/src/post_create.sh

USER vscode
