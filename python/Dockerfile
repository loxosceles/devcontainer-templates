ARG VARIANT=ubuntu-24.04
FROM mcr.microsoft.com/devcontainers/python:${VARIANT}

LABEL dev.containers.features="python"

WORKDIR /home/vscode

COPY post_create.sh chezmoi.toml /usr/src/
RUN chmod +x /usr/src/post_create.sh

# Install Python-specific tools
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    git libzip-dev unzip \
    ranger gnupg curl \
    build-essential python3-dev \
    && apt-get clean

COPY requirements.txt /usr/src/
RUN pip install -r /usr/src/requirements.txt