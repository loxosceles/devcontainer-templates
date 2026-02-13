# Common Devcontainer Scripts

This directory contains shared scripts used across all devcontainer templates.

## Files

### `post_create.sh`

Universal post-create script that handles common setup tasks for all project types (TypeScript, JavaScript, Python, etc.).

**Features**:
- SSH configuration setup
- Chezmoi dotfiles initialization
- ZSH configuration linking
- AI agent template symlinking (for projects with `docs/ai-dev-rules/agents`)
- Project-specific setup hook support

**Usage**:

Each template's `post_create.sh` sources this common script:

```sh
#!/bin/sh
# Source the common post-create script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
COMMON_SCRIPT="${SCRIPT_DIR}/../common/post_create.sh"

if [ -f "$COMMON_SCRIPT" ]; then
  echo "Running common post-create setup..."
  . "$COMMON_SCRIPT"
else
  echo "Error: Common post-create script not found"
  exit 1
fi
```

**Configuration Variables**:

All variables have sensible defaults and can be overridden via environment variables in `devcontainer.json`:

- `WORKSPACE_ROOT` - Project directory (default: `/workspaces/$(basename "$PWD")`)
  - **Required in devcontainer.json**: `"WORKSPACE_ROOT": "${containerWorkspaceFolder}"`
- `SSH_CONTEXT` - SSH context name (default: `default`)
- `CHEZMOI_DOTFILES_REPOSITORY` - Dotfiles repo URL (default: `git@github.com:/${GITHUB_USERNAME}/devcontainer-dotfiles`)
- `AGENT_SOURCE_DIR` - AI agent templates source (default: `${WORKSPACE_ROOT}/docs/ai-dev-rules/agents`)
- `AGENT_TARGETS` - AI agent target directories (default: `.github/agents .amazonq/agents`)

**Important**: All templates must include `WORKSPACE_ROOT` in their `containerEnv` section:

```json
"containerEnv": {
  "WORKSPACE_ROOT": "${containerWorkspaceFolder}"
}
```

**Project-Specific Setup**:

To add project-specific setup, create a `post_create_project.sh` file in your template's `.devcontainer` directory. This script will be automatically executed after the common setup completes.

Example `post_create_project.sh`:

```sh
#!/bin/sh
# TypeScript-specific setup

# Set tmux session name
TMUX_SESSION="vsc-$(basename "$PWD")"
export TMUX_SESSION
echo "export TMUX_SESSION=\"$TMUX_SESSION\"" >>"$HOME/.zshrc.local"

echo "✓ TypeScript-specific setup complete"
```

## Setup Flow

1. **Template's `post_create.sh`** - Sources the common script
2. **Common `post_create.sh`** - Runs universal setup (SSH, dotfiles, ZSH, agents)
3. **Project-specific `post_create_project.sh`** - Runs template-specific setup (if exists)

## Benefits

- **Single Source of Truth**: Common setup logic in one place
- **Easy Maintenance**: Update once, applies to all templates
- **Project Agnostic**: Works for TypeScript, Python, Node.js, etc.
- **Extensible**: Templates can add project-specific setup via `post_create_project.sh`
- **Graceful Degradation**: Skips optional features if not available (e.g., AI agents)

## AI Agent Template Support

The common script automatically sets up AI agent templates if the project has them:

1. Checks for `docs/ai-dev-rules/agents` directory
2. Counts available `.agent.md` files
3. Creates target directories (`.github/agents`, `.amazonq/agents`)
4. Symlinks all agent files to target directories

This enables projects using the [ai-coding-standards](https://github.com/loxosceles/ai-coding-standards) repository to automatically have agent templates available in their devcontainer.

**Projects without AI agents**: The script gracefully skips this step with an info message.

## Updating Templates

When updating the common script:

1. Edit `common/post_create.sh`
2. Test with multiple template types (TypeScript, Python, etc.)
3. Ensure backward compatibility
4. Update this README if adding new features

## Migration from Old Templates

Old templates had all setup logic in their individual `post_create.sh` files. To migrate:

1. Replace template's `post_create.sh` with the sourcing pattern (see Usage above)
2. Move template-specific logic to `post_create_project.sh`
3. Remove duplicated common logic (SSH, dotfiles, ZSH)
4. Test the template

## Related Documentation

- [Devcontainer Templates README](../README.md) - Main documentation
- [AI Coding Standards](https://github.com/loxosceles/ai-coding-standards) - Universal agent templates
