#!/bin/sh
# Main post-create script - sources the common setup
# See common/post_create.sh for the universal setup logic

# Source the common post-create script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
COMMON_SCRIPT="${SCRIPT_DIR}/../common/post_create.sh"

if [ -f "$COMMON_SCRIPT" ]; then
  echo "Running common post-create setup..."
  . "$COMMON_SCRIPT"
else
  echo "Error: Common post-create script not found at: $COMMON_SCRIPT"
  echo "Please ensure the common directory exists in devcontainer-templates"
  exit 1
fi
