# Devcontainer Configuration Templates

## Description

This repository contains templates for development container environments in
Visual Studio Code. These are intended to be used as blueprints with very little
configuration needed to get started with a specific container environment.

The template uses a configuration manager [Chezmoi](https://www.chezmoi.io/) to
automatically pull your own dot files into the container. This way you can have
your own shell configuration, aliases, etc. available in the container, even
after the container is destroyed and recreated.

All templates use a [common post-create script](common/README.md) for consistent setup across project types. See the Common Scripts section below for details.

## Quick Start

**Choose and download a template environment into your project:**

Available environments: `python-minimal`, `python-ubuntu`, `nodejs`, `typescript`, `aws`, `multipurpose`, `minimal`.

```sh
# Example: Download TypeScript environment template
mkdir .devcontainer
curl -L https://github.com/loxosceles/devcontainer-templates/archive/main.tar.gz | tar -xz --strip-components=2 -C .devcontainer devcontainer-templates-main/typescript

# Also download the common scripts
curl -L https://github.com/loxosceles/devcontainer-templates/archive/main.tar.gz | tar -xz --strip-components=2 -C .devcontainer devcontainer-templates-main/common
```

Replace `typescript` with your desired environment (e.g., `python-minimal`, `nodejs`, `aws`).

**Important**: Always download both the template AND the `common` directory, as templates depend on shared scripts.

## Setup

- Create a _personal_ dotfiles repository on github. This repository will contain
  your dotfiles and configuration files. It can be empty initially. It is
  recommend to go by the naming convention `devcontainer-dotfiles`.

- Make sure that you have your ssh keys ready inside `${HOME}/.ssh` folder on
  your local machine. All keys inside the default `.ssh` directory will be
  mounted into the project's dev container and enable you to pull and push to
  your dotfile repo, as well as your project repo.
  In case that you store your keys somewhere else or only want to
  mount in specific keys, edit the `devcontainer.json` file, modifying the
  source in the `mount` section, e.g.:

  ```json
    "mount": [
        "source=${localEnv:HOME}/<MY_ALTERNATIVE_SSH_DIRECTORY>/id_rsa,target=/root/.ssh/id_rsa,type=bind,consistency=cached"
    ]
  ```

- Download your desired environment template (see [Quick Start](#quick-start) above)

- Copy all files ending with `TEMPLATE` inside the `.devcontainer` folder to new files and name them exactly in the same way, just without the `_TEMPLATE` suffix, e.g., `.env_TEMPLATE` becomes `.env`.

- Update the `.env` file with your Github username. This is needed to be able to use the `chezmoi` tool to pull your dotfiles from your personal dotfiles repository.
- Update the `chezmoi.toml` file with your own email address and name.
- Change the `devcontainer.json` file to your needs. There are a few features and extension enabled by default in the `devcontainer.json` file. You can remove or add more features and extensions as needed, see the [Customization](#customization) section below. Keep in mind, building time will increase with more features and extensions.

## Customization

Note that this default configuration contains a `package.json` and
`requirements.txt` files. You can edit them (or remove them if you don't want to install specific NodeJS or Python packages. These dependencies will be available globally on the dev container system after building is finished.

Some of the features might be interesting, you can enable them by pasting the
ones you want to use under the `features` key.

**Note:** For better build performance, consider installing tools directly in the Dockerfile using `apt-get` or official installation scripts instead of using features. Features can be slower on rebuilds and increase container build times. The `python` container directory provides an example of this approach.

```json
    "ghcr.io/devcontainers-contrib/features/fzf:1": {
      "version": "latest"
    },
    "ghcr.io/devcontainers-contrib/features/tmux-apt-get:1": {},
    "ghcr.io/devcontainers-contrib/features/zsh-plugins:0": {
      "plugins": "ssh-agent npm",
      "omzPlugins": "https://github.com/zsh-users/zsh-autosuggestions",
      "username": "vscode"
    },
    "ghcr.io/devcontainers-contrib/features/neovim-apt-get:1": {},
    "ghcr.io/devcontainers-contrib/features/pre-commit:2": {
      "version": "latest"
    },
    "ghcr.io/devcontainers/features/python:1": {
      "installTools": true,
      "version": "latest"
    },
    "ghcr.io/devcontainers-contrib/features/pipenv:2": {
      "version": "latest"
    },
    "ghcr.io/devcontainers-contrib/features/black:2": {
      "version": "latest"
    },
    "ghcr.io/devcontainers/features/node:1": {
      "nodeGypDependencies": true,
      "version": "lts"
    },
    "ghcr.io/devcontainers/features/sshd:1": {
      "version": "latest"
    },
    "ghcr.io/devcontainers-contrib/features/typescript:2": {
      "version": "latest"
    },
    "ghcr.io/devcontainers/features/aws-cli:1": {}
```

Here is a curated list of useful extensions, which you can paste into under the
`extensions` key. These are mainly for Python and Javascript development but
some are useful for general development, as well.

```json
        "riccardoNovaglia.missinglineendoffile",
        "foxundermoon.shell-format",
        "eamodio.gitlens",
        "vscodevim.vim",
        "ms-python.pylint",
        "ms-python.python",
        "ms-python.mypy-type-checker",
        "ms-python.vscode-pylance",
        "ms-python.black-formatter",
        "rvest.vs-code-prettier-eslint",
        "esbenp.prettier-vscode",
        "ms-vscode.vscode-typescript-next",
        "infeng.vscode-react-typescript",
        "morissonmaciel.typescript-auto-compiler",
        "Gydunhn.typescript-essentials",
        "Shelex.vscode-cy-helper",
        "atlassian.atlascode",
        "GitHub.copilot",
        "GitHub.copilot-chat",
        "GitHub.vscode-github-actions",
        "njpwerner.autodocstring",
        "amazonwebservices.aws-toolkit-vscode",
        "mark-tucker.aws-cli-configure",
        "Boto3typed.boto3-ide"
```

Your will want some settings to be automatically applied, when you build your
devcontainer. This depends very much on the features and extensions you are
using, among others things. One obvious example, is the linter configuration,
e.g., if you use `black` as a formatter, you will want to set it as the default
formatter for Python files.

Here is an example of how you can set up some settings under the `settings` key,
note that some of these settings are scoped to specific languages:

```json
        "editor.formatOnSave": true,
        "[typescript][typescriptreact][javascript][javascriptreact]": {
          "editor.defaultFormatter": "rvest.vs-code-prettier-eslint",
          "vs-code-prettier-eslint.prettierLast": false
        },
        "[python]": {
          "editor.defaultFormatter": "ms-python.black-formatter"
        }
```

You can also customize the `post_create.sh` which runs after the container is created. This script can be used to install additional software, set up additional configurations, etc. Here it is used mainly to set up the Chezmoi configuration and apply your configs right from the start.

## Quick Start with Chezmoi

In this example, we will only configure the `.zshrc` file. You can configure other files in the same way. For more advanced use, like Chezmoi templates, see the [Chezmoi documentation](https://www.chezmoi.io/reference).

We install the [direnv](https://direnv.net/) hook into the `.zshrc` file. This
way, we can automatically load the `.envrc` file when we enter the project
directory. It will also be unloaded when we leave the project directory.

- Create a `.envrc` file for your project in the root directory:

```sh
# This is just an example. You would use that for something useful, like setting environment variables.
echo "echo 'Loading .envrc'" > .envrc
```

- Install the direnv hook for zsh:

```sh
  echo eval "$(direnv hook zsh)" > ~/.zshrc
```

- Make the change known to Chezmoi, so that the file will be stored in your dotfiles repository:

```sh
  chezmoi add ~/.zshrc
```

- Apply the changes to your environment:

```sh
  chezmoi apply
```

- Commit the changes to your dotfiles repository:

```sh
  chezmoi cd
  git add .zshrc
  git commit -m "Add direnv hook to zshrc"
  git push
```

Next time, when you rebuild your container, the `.zshrc` file will be pulled from your dotfiles repository automatically and the change is applied without the need for further action.

## Template Structure

### Common Scripts

All templates now share common setup logic in the `common/` directory:

- **`common/post_create.sh`** - Universal post-create script handling SSH, dotfiles, ZSH, and AI agent setup
- **`common/README.md`** - Documentation for common scripts

Each template's `post_create.sh` sources the common script and can optionally provide a `post_create_project.sh` for template-specific setup.

**Benefits**:
- Single source of truth for common setup
- Easy maintenance (update once, applies everywhere)
- Project-agnostic (works for TypeScript, Python, Node.js, etc.)
- Graceful degradation (skips optional features if not available)

See [Common Scripts README](common/README.md) for detailed documentation.

### AI Agent Template Support

Templates automatically set up AI agent templates if your project uses [ai-coding-standards](https://github.com/loxosceles/ai-coding-standards):

1. Detects `docs/ai-dev-rules/agents` directory
2. Symlinks agent templates to `.github/agents` and `.amazonq/agents`
3. Makes agents available in GitHub Copilot and Amazon Q

Projects without AI agents gracefully skip this step.

## Maintainer(s)

If you encounter any problems while using this template, please let me know, so that I can improve it.

dev at loxosceles dot me
