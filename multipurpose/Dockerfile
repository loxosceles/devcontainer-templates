ARG VARIANT=ubuntu-22.04
FROM mcr.microsoft.com/devcontainers/base:${VARIANT}

LABEL dev.containers.features="multipurpose"

WORKDIR /home/vscode

COPY post_create.sh chezmoi.toml /usr/src/
RUN chmod +x /usr/src/post_create.sh

# Install general development tools
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    git pip libzip-dev unzip software-properties-common \
    ranger gnupg curl build-essential \
    && apt-get clean

# Install Python and Node.js for general purpose development
COPY requirements.txt /usr/src/
RUN pip install -r /usr/src/requirements.txt

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash - && \
    apt-get install -y nodejs

COPY package*.json ./
RUN npm install

# Add node_modules/.bin to PATH
ENV PATH=/home/vscode/node_modules/.bin:$PATH