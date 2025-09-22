#!/bin/sh

mkdir -p "$HOME"/.config/chezmoi
# In the Dockerfile we copied the config file to /usr/src
sudo mv /usr/src/chezmoi.toml "$HOME"/.config/chezmoi/chezmoi.toml
sudo chown -R "$USER":"$USER" "$HOME"/.config/chezmoi

# Setup dotfiles
echo "Setting up dotfiles..."
CHEZMOI_DOTFILES_REPOSITORY="git@github.com:/${GITHUB_USERNAME}/devcontainer-dotfiles"
chezmoi init --apply "${CHEZMOI_DOTFILES_REPOSITORY}"
