#!/bin/sh
set -e

git config -f "$HOME/.gitconfig" user.name "${GIT_NAME}"
git config -f "$HOME/.gitconfig" user.email "${GIT_EMAIL}"

echo "export TMUX_SESSION=\"vsc-${PROJECT_NAME}\"" >> "$HOME/.zshrc.local"


# Link AI agent templates
AGENT_SRC="${WORKSPACE_ROOT}/docs/ai-dev-rules/agents"
if [ -d "$AGENT_SRC" ]; then
  for target in .github/agents .amazonq/agents; do
    mkdir -p "${WORKSPACE_ROOT}/${target}"
    for f in "$AGENT_SRC"/*.agent.md; do
      [ -e "$f" ] && ln -sf "$f" "${WORKSPACE_ROOT}/${target}/"
    done
  done
  echo "✓ AI agents linked"
fi

echo "✓ Devcontainer setup complete!"
