#!/bin/sh
# TypeScript-specific post-create setup
# This script runs after the common post_create.sh

# Set project-specific tmux session name
TMUX_SESSION="vsc-$(basename "$PWD")"
export TMUX_SESSION
echo "export TMUX_SESSION=\"vsc-$(basename "$PWD")\"" >>"$HOME/.zshrc.local"

echo "✓ TypeScript-specific setup complete"
