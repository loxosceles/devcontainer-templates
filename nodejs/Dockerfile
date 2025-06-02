ARG VARIANT=ubuntu-24.04
FROM mcr.microsoft.com/devcontainers/javascript-node:${VARIANT}

LABEL dev.containers.features="nodejs"

WORKDIR /home/vscode

COPY post_create.sh chezmoi.toml /usr/src/
RUN chmod +x /usr/src/post_create.sh

# Install Node.js specific tools
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    git unzip \
    ranger gnupg curl \
    && apt-get clean

COPY package*.json ./
RUN npm install

# Add node_modules/.bin to PATH
ENV PATH=/home/vscode/node_modules/.bin:$PATH