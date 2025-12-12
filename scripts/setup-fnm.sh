#!/usr/bin/env bash

################################################################################
# FNM (Fast Node Manager) Setup Script
#
# This script installs and configures fnm, Node.js, and pnpm
#
# What it does:
# - Installs fnm via Homebrew or official installer
# - Configures shell integration with auto-switching
# - Installs Node.js LTS versions
# - Enables and configures Corepack
# - Installs and configures pnpm
# - Sets up useful aliases
#
# Usage:
#   chmod +x setup-fnm.sh
#   ./setup-fnm.sh
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "macos" ;;
        Linux*)  echo "linux" ;;
        *)       echo "unknown" ;;
    esac
}

# Detect shell
detect_shell() {
    if [ -n "$ZSH_VERSION" ]; then
        echo "zsh"
    elif [ -n "$BASH_VERSION" ]; then
        echo "bash"
    else
        echo "unknown"
    fi
}

OS=$(detect_os)
SHELL_TYPE=$(detect_shell)

if [ "$SHELL_TYPE" = "zsh" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ "$SHELL_TYPE" = "bash" ]; then
    SHELL_CONFIG="$HOME/.bash_profile"
else
    SHELL_CONFIG="$HOME/.bashrc"
fi

info "Detected OS: $OS"
info "Detected shell: $SHELL_TYPE"
info "Shell config: $SHELL_CONFIG"

################################################################################
# Step 1: Install fnm
################################################################################

info "Installing fnm..."

if command -v fnm &> /dev/null; then
    warning "fnm is already installed at $(which fnm)"
    CURRENT_VERSION=$(fnm --version | awk '{print $2}')
    info "Current version: $CURRENT_VERSION"
    read -p "Do you want to update fnm? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ "$OS" = "macos" ] && command -v brew &> /dev/null; then
            info "Updating fnm via Homebrew..."
            brew upgrade fnm
            success "fnm updated successfully"
        else
            info "Updating fnm via curl..."
            curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
            success "fnm updated successfully"
        fi
    else
        info "Skipping fnm installation"
    fi
else
    if [ "$OS" = "macos" ] && command -v brew &> /dev/null; then
        info "Installing fnm via Homebrew..."
        brew install fnm
        success "fnm installed via Homebrew"
    else
        info "Installing fnm via official installer..."
        curl -fsSL https://fnm.vercel.app/install | bash
        success "fnm installed successfully"
    fi
fi

################################################################################
# Step 2: Configure Shell
################################################################################

info "Configuring shell integration..."

# Check if fnm is already in shell config
FNM_CONFIG_MARKER="# FNM (Fast Node Manager) Setup"

if grep -q "$FNM_CONFIG_MARKER" "$SHELL_CONFIG"; then
    warning "fnm configuration already exists in $SHELL_CONFIG"
    info "Skipping shell configuration"
else
    info "Adding fnm configuration to $SHELL_CONFIG"

    if [ "$SHELL_TYPE" = "zsh" ]; then
        cat >> "$SHELL_CONFIG" << 'EOF'

# ------------------------------------
# FNM (Fast Node Manager) Setup
# - Manages Node.js versions
# - Auto-switches based on .node-version or .nvmrc
# - Enables Corepack for pnpm/yarn management
# ------------------------------------
export FNM_DIR="$HOME/.local/share/fnm"
export FNM_COREPACK_ENABLED=true
export FNM_RESOLVE_ENGINES=true

eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"

# FNM Aliases
alias n="fnm"
alias nls="fnm list"
alias nuse="fnm use"
alias ni="fnm install"
alias ncurrent="fnm current"
EOF
    else
        cat >> "$SHELL_CONFIG" << 'EOF'

# ------------------------------------
# FNM (Fast Node Manager) Setup
# - Manages Node.js versions
# - Auto-switches based on .node-version or .nvmrc
# - Enables Corepack for pnpm/yarn management
# ------------------------------------
export FNM_DIR="$HOME/.local/share/fnm"
export FNM_COREPACK_ENABLED=true
export FNM_RESOLVE_ENGINES=true

eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"

# FNM Aliases
alias n="fnm"
alias nls="fnm list"
alias nuse="fnm use"
alias ni="fnm install"
alias ncurrent="fnm current"
EOF
    fi

    success "Shell configuration added"
fi

# Source fnm for current session
export FNM_DIR="$HOME/.local/share/fnm"
export FNM_COREPACK_ENABLED=true
export FNM_RESOLVE_ENGINES=true

if [ "$SHELL_TYPE" = "zsh" ]; then
    eval "$(fnm env --use-on-cd --version-file-strategy=recursive 2>/dev/null || true)"
else
    eval "$(fnm env --use-on-cd --version-file-strategy=recursive 2>/dev/null || true)"
fi

################################################################################
# Step 3: Install Node.js Versions
################################################################################

info "Installing Node.js versions..."

# Function to install Node if not present
install_node_version() {
    local version=$1
    local description=$2

    if fnm list | grep -q "v$version"; then
        info "Node.js $version ($description) already installed"
    else
        info "Installing Node.js $version ($description)..."
        fnm install "$version"
        success "Node.js $version installed"
    fi
}

# Install LTS versions
info "Installing Node.js LTS versions..."
fnm install --lts

# Install Node 18 LTS (for legacy projects)
if ! fnm list | grep -q "v18"; then
    info "Installing Node.js 18 LTS (Hydrogen) for legacy projects..."
    fnm install 18
fi

# Set default to latest LTS
info "Setting default Node.js version..."
LATEST_LTS=$(fnm list | grep "lts-latest" | awk '{print $2}' | sed 's/v//')
if [ -n "$LATEST_LTS" ]; then
    fnm default "$LATEST_LTS"
    success "Default Node.js version set to $LATEST_LTS"
else
    # Fallback: set default to Node 20
    fnm default 20 2>/dev/null || fnm default lts-latest 2>/dev/null || true
fi

info "Installed Node.js versions:"
fnm list

################################################################################
# Step 4: Enable Corepack
################################################################################

info "Enabling Corepack for package manager management..."

# Make sure we're using the fnm Node
eval "$(fnm env)"

if command -v corepack &> /dev/null; then
    info "Enabling Corepack..."
    corepack enable 2>/dev/null || true
    success "Corepack enabled"
else
    warning "Corepack not found. It should be included with Node.js 16+"
    warning "Your Node.js version may be too old."
fi

################################################################################
# Step 5: Install and Configure pnpm
################################################################################

info "Installing and configuring pnpm..."

if command -v corepack &> /dev/null; then
    info "Installing latest pnpm via Corepack..."
    corepack prepare pnpm@latest --activate 2>/dev/null || true

    if command -v pnpm &> /dev/null; then
        success "pnpm installed: $(pnpm --version)"

        # Configure pnpm
        info "Configuring pnpm..."
        pnpm config set store-dir "$HOME/.pnpm-store" 2>/dev/null || true
        pnpm config set auto-install-peers true 2>/dev/null || true

        success "pnpm configured"
    else
        warning "pnpm installation may have failed. Try running: corepack prepare pnpm@latest --activate"
    fi
else
    warning "Cannot install pnpm without Corepack. Please ensure Node.js 16+ is installed."
fi

################################################################################
# Step 6: Create Project Templates (Optional)
################################################################################

read -p "Do you want to create a template directory with example .node-version files? [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    TEMPLATE_DIR="$HOME/.node-templates"

    mkdir -p "$TEMPLATE_DIR"

    # Node 20 template
    echo "20" > "$TEMPLATE_DIR/.node-version-20"

    # Node 18 template
    echo "18" > "$TEMPLATE_DIR/.node-version-18"

    # Create example package.json
    cat > "$TEMPLATE_DIR/package.json.example" << 'EOF'
{
  "name": "my-project",
  "version": "1.0.0",
  "type": "module",
  "engines": {
    "node": ">=20.0.0",
    "pnpm": ">=8.0.0"
  },
  "scripts": {
    "dev": "node --watch src/index.js",
    "start": "node src/index.js",
    "test": "node --test"
  },
  "devDependencies": {}
}
EOF

    # Create example .npmrc
    cat > "$TEMPLATE_DIR/.npmrc.example" << 'EOF'
shamefully-hoist=false
strict-peer-dependencies=true
auto-install-peers=true
engine-strict=true
EOF

    success "Templates created at $TEMPLATE_DIR"
    info "Copy these files to new projects:"
    echo "  cp $TEMPLATE_DIR/.node-version-20 my-project/.node-version"
    echo "  cp $TEMPLATE_DIR/package.json.example my-project/package.json"
    echo "  cp $TEMPLATE_DIR/.npmrc.example my-project/.npmrc"
fi

################################################################################
# Step 7: Verification
################################################################################

info "Verifying installation..."

# Verify fnm
if command -v fnm &> /dev/null; then
    success "fnm is installed: $(fnm --version)"
else
    error "fnm command not found. Please restart your terminal and try again."
    exit 1
fi

# Verify Node.js
if command -v node &> /dev/null; then
    success "Node.js is installed: $(node --version)"
else
    error "Node.js command not found. Please restart your terminal and try again."
    exit 1
fi

# Verify npm
if command -v npm &> /dev/null; then
    success "npm is installed: $(npm --version)"
else
    warning "npm command not found."
fi

# Verify pnpm
if command -v pnpm &> /dev/null; then
    success "pnpm is installed: $(pnpm --version)"
else
    warning "pnpm command not found. Run: corepack prepare pnpm@latest --activate"
fi

################################################################################
# Summary
################################################################################

echo ""
echo "=================================="
success "FNM Setup Complete!"
echo "=================================="
echo ""
echo "Installed:"
echo "  - fnm: $(fnm --version 2>/dev/null || echo 'N/A')"
echo "  - Node.js: $(node --version 2>/dev/null || echo 'N/A')"
echo "  - npm: $(npm --version 2>/dev/null || echo 'N/A')"
echo "  - pnpm: $(pnpm --version 2>/dev/null || echo 'N/A')"
echo ""
echo "Node.js versions:"
fnm list 2>/dev/null || echo "  Run 'fnm list' after restarting terminal"
echo ""
echo "Configuration:"
echo "  - Shell config: $SHELL_CONFIG"
echo "  - fnm directory: $HOME/.local/share/fnm"
echo "  - pnpm store: $HOME/.pnpm-store"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source $SHELL_CONFIG"
echo "  2. Verify installation: fnm list && node --version && pnpm --version"
echo "  3. Create a test project:"
echo "       mkdir test-node && cd test-node"
echo "       echo '20' > .node-version"
echo "       pnpm init"
echo "       pnpm add express"
echo ""
echo "Useful commands:"
echo "  fnm install 20          - Install Node.js 20"
echo "  fnm list                - List installed versions"
echo "  fnm use 20              - Use Node.js 20"
echo "  pnpm add <package>      - Add package"
echo "  pnpm install            - Install dependencies"
echo "  pnpm run dev            - Run dev script"
echo ""
echo "Auto-switching:"
echo "  When you cd into a directory with .node-version or .nvmrc,"
echo "  fnm will automatically switch to that Node.js version!"
echo ""
echo "Documentation:"
echo "  - fnm: https://github.com/Schniz/fnm"
echo "  - pnpm: https://pnpm.io/motivation"
echo ""
