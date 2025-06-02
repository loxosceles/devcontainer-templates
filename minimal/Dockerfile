FROM alpine:3.19

# Install minimal required packages
RUN apk add --no-cache \
    git \
    curl \
    bash \
    zsh \
    tmux \
    openssh-client \
    ca-certificates \
    && addgroup -g 1001 vscode \
    && adduser -u 1001 -G vscode -s /bin/zsh -D vscode

# Create workspace directory
RUN mkdir -p /workspace && chown vscode:vscode /workspace

# Switch to vscode user
USER vscode
WORKDIR /workspace

# Install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Set zsh as default shell
ENV SHELL=/bin/zsh