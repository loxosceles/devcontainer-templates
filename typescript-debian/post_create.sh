#!/bin/sh
set -e

git config -f "$HOME/.gitconfig" user.name "${GIT_NAME}"
git config -f "$HOME/.gitconfig" user.email "${GIT_EMAIL}"

echo "export TMUX_SESSION=\"vsc-${PROJECT_NAME}\"" >> "$HOME/.zshrc.local"

echo "✓ Devcontainer setup complete!"
