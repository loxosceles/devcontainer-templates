ARG VARIANT=22-bookworm
FROM mcr.microsoft.com/devcontainers/typescript-node:${VARIANT}

# Dev tooling + AWS CLI (arch-aware for Apple Silicon) + GitHub CLI
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    neovim ranger tmux direnv zsh unzip \
    # AWS CLI v2
    && curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o /tmp/awscliv2.zip \
    && unzip -q /tmp/awscliv2.zip -d /tmp && /tmp/aws/install && rm -rf /tmp/aws /tmp/awscliv2.zip \
    # GitHub CLI (for setup-github-vars.sh and PR workflows)
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
       > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update && apt-get -y install --no-install-recommends gh \
    # Cleanup
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && usermod -s /usr/bin/zsh node

COPY --chown=node:node post_create.sh /usr/src/
RUN chmod +x /usr/src/post_create.sh
