#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
REPO_URL="https://github.com/loxosceles/devcontainer-templates"
TEMPLATES=("typescript" "python-minimal" "python-ubuntu" "nodejs" "aws" "multipurpose" "minimal")

print_error() { echo -e "${RED}✗ $1${NC}" >&2; }
print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_info() { echo -e "${YELLOW}ℹ $1${NC}"; }

show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Automated setup for devcontainer templates.

OPTIONS:
    --template <name>       Template to use (${TEMPLATES[*]})
    --github-user <user>    GitHub username
    --email <email>         Email for git config
    --name <name>           Full name for git config
    --ssh-context <name>    SSH context to use (default: project directory name)
    --help                  Show this help message

EXAMPLES:
    # Interactive mode
    $0

    # Non-interactive mode (for LLM automation)
    $0 --template typescript --github-user myuser --email dev@example.com --name "Dev User"

EOF
}

validate_template() {
    local template=$1
    for t in "${TEMPLATES[@]}"; do
        if [[ "$t" == "$template" ]]; then
            return 0
        fi
    done
    return 1
}

# Parse arguments
TEMPLATE=""
GITHUB_USER=""
EMAIL=""
NAME=""
SSH_CONTEXT=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --template)
            TEMPLATE="$2"
            shift 2
            ;;
        --github-user)
            GITHUB_USER="$2"
            shift 2
            ;;
        --email)
            EMAIL="$2"
            shift 2
            ;;
        --name)
            NAME="$2"
            shift 2
            ;;
        --ssh-context)
            SSH_CONTEXT="$2"
            shift 2
            ;;
        --help)
            show_usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Interactive prompts if values not provided
if [[ -z "$TEMPLATE" ]]; then
    echo "Available templates:"
    for i in "${!TEMPLATES[@]}"; do
        echo "  $((i+1)). ${TEMPLATES[$i]}"
    done
    read -p "Select template (1-${#TEMPLATES[@]}): " selection
    TEMPLATE="${TEMPLATES[$((selection-1))]}"
fi

if ! validate_template "$TEMPLATE"; then
    print_error "Invalid template: $TEMPLATE"
    exit 1
fi

if [[ -z "$GITHUB_USER" ]]; then
    # Try to auto-detect from git config
    GIT_USER=$(git config --global github.user 2>/dev/null || echo "")
    if [[ -n "$GIT_USER" ]]; then
        read -p "GitHub username [$GIT_USER]: " input
        GITHUB_USER="${input:-$GIT_USER}"
    else
        read -p "GitHub username: " GITHUB_USER
    fi
fi

if [[ -z "$EMAIL" ]]; then
    GIT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")
    if [[ -n "$GIT_EMAIL" ]]; then
        read -p "Email [$GIT_EMAIL]: " input
        EMAIL="${input:-$GIT_EMAIL}"
    else
        read -p "Email: " EMAIL
    fi
fi

if [[ -z "$NAME" ]]; then
    GIT_NAME=$(git config --global user.name 2>/dev/null || echo "")
    if [[ -n "$GIT_NAME" ]]; then
        read -p "Full name [$GIT_NAME]: " input
        NAME="${input:-$GIT_NAME}"
    else
        read -p "Full name: " NAME
    fi
fi

# Default SSH context to current directory name if not specified
if [[ -z "$SSH_CONTEXT" ]]; then
    DEFAULT_CONTEXT=$(basename "$PWD")
    read -p "SSH context name [$DEFAULT_CONTEXT]: " input
    SSH_CONTEXT="${input:-$DEFAULT_CONTEXT}"
fi

# Validate SSH context setup
print_info "Checking SSH context setup..."

if [[ ! -d "$HOME/.ssh/contexts" ]]; then
    print_error "SSH contexts directory not found"
    echo ""
    echo "Create an SSH context for this project:"
    echo "  mkdir -p ~/.ssh/contexts/$SSH_CONTEXT"
    echo "  ssh-keygen -t ed25519 -C \"$EMAIL\" -f ~/.ssh/contexts/$SSH_CONTEXT/id_ed25519"
    echo "  cat > ~/.ssh/contexts/$SSH_CONTEXT/config << 'EOF'"
    echo "Host github.com"
    echo "  IdentityFile ~/.ssh/contexts/$SSH_CONTEXT/id_ed25519"
    echo "EOF"
    echo ""
    echo "Then add the public key to GitHub and re-run this script."
    exit 1
fi

# Check if at least one context exists
if [[ -z "$(ls -A $HOME/.ssh/contexts 2>/dev/null)" ]]; then
    print_error "No SSH contexts found"
    echo ""
    echo "Create an SSH context for this project:"
    echo "  mkdir -p ~/.ssh/contexts/$SSH_CONTEXT"
    echo "  ssh-keygen -t ed25519 -C \"$EMAIL\" -f ~/.ssh/contexts/$SSH_CONTEXT/id_ed25519"
    echo "  cat > ~/.ssh/contexts/$SSH_CONTEXT/config << 'EOF'"
    echo "Host github.com"
    echo "  IdentityFile ~/.ssh/contexts/$SSH_CONTEXT/id_ed25519"
    echo "EOF"
    echo ""
    echo "Then add the public key to GitHub and re-run this script."
    exit 1
fi

print_success "SSH contexts found: $(ls $HOME/.ssh/contexts | tr '\n' ' ')"

# Verify the selected context exists
if [[ ! -d "$HOME/.ssh/contexts/$SSH_CONTEXT" ]]; then
    print_error "SSH context '$SSH_CONTEXT' not found"
    echo ""
    echo "Create this SSH context:"
    echo "  mkdir -p ~/.ssh/contexts/$SSH_CONTEXT"
    echo "  ssh-keygen -t ed25519 -C \"$EMAIL\" -f ~/.ssh/contexts/$SSH_CONTEXT/id_ed25519"
    echo "  cat > ~/.ssh/contexts/$SSH_CONTEXT/config << 'EOF'"
    echo "Host github.com"
    echo "  IdentityFile ~/.ssh/contexts/$SSH_CONTEXT/id_ed25519"
    echo "EOF"
    echo ""
    echo "Available contexts: $(ls $HOME/.ssh/contexts | tr '\n' ' ')"
    echo "Then add the public key to GitHub and re-run this script."
    exit 1
fi

print_success "Using SSH context: $SSH_CONTEXT"

# Create .devcontainer directory
print_info "Setting up .devcontainer directory..."
mkdir -p .devcontainer
cd .devcontainer

# Determine branch/ref to use
BRANCH="${DEVCONTAINER_TEMPLATES_BRANCH:-main}"
# GitHub replaces slashes with dashes in archive names
ARCHIVE_PREFIX="devcontainer-templates-${BRANCH//\//-}"

# Download template
print_info "Downloading $TEMPLATE template..."
curl -fsSL "${REPO_URL}/archive/${BRANCH}.tar.gz" | tar -xz --strip-components=2 "${ARCHIVE_PREFIX}/$TEMPLATE"

# Download common scripts  
print_info "Downloading common scripts..."
mkdir -p common
curl -fsSL "${REPO_URL}/archive/${BRANCH}.tar.gz" | tar -xz --strip-components=2 -C common "${ARCHIVE_PREFIX}/common"

# Process template files
print_info "Configuring template files..."

if [[ -f ".env_TEMPLATE" ]]; then
    sed "s/<YOUR_GITHUB_USERNAME>/$GITHUB_USER/g" .env_TEMPLATE > .env
    print_success "Created .env"
fi

if [[ -f "chezmoi_TEMPLATE.toml" ]]; then
    sed -e "s/YOUR-EMAIL/$EMAIL/g" \
        -e "s/YOUR-NAME/$NAME/g" \
        chezmoi_TEMPLATE.toml > chezmoi.toml
    print_success "Created chezmoi.toml"
fi

cd ..

# Update SSH_CONTEXT in devcontainer.json
print_info "Updating SSH_CONTEXT to '$SSH_CONTEXT' in devcontainer.json..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/\"SSH_CONTEXT\": \"personal\"/\"SSH_CONTEXT\": \"$SSH_CONTEXT\"/" .devcontainer/devcontainer.json
else
    sed -i "s/\"SSH_CONTEXT\": \"personal\"/\"SSH_CONTEXT\": \"$SSH_CONTEXT\"/" .devcontainer/devcontainer.json
fi

print_success "Setup complete!"
echo ""
print_info "Next steps:"
echo "  1. Review .devcontainer/devcontainer.json for customization"
echo "  2. Open this folder in VS Code"
echo "  3. Click 'Reopen in Container' when prompted"
echo ""
print_info "Optional: Create a dotfiles repository at github.com/$GITHUB_USER/devcontainer-dotfiles"
