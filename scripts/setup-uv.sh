#!/usr/bin/env bash

################################################################################
# UV Setup Script
#
# This script installs and configures uv - a fast Python package manager
#
# What it does:
# - Installs uv via official installer
# - Configures shell integration (zsh/bash)
# - Installs commonly used Python versions
# - Sets up useful aliases
# - Creates directory structure for shared environments
#
# Usage:
#   chmod +x setup-uv.sh
#   ./setup-uv.sh
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

SHELL_TYPE=$(detect_shell)
if [ "$SHELL_TYPE" = "zsh" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ "$SHELL_TYPE" = "bash" ]; then
    SHELL_CONFIG="$HOME/.bash_profile"
else
    SHELL_CONFIG="$HOME/.bashrc"
fi

info "Detected shell: $SHELL_TYPE"
info "Shell config: $SHELL_CONFIG"

################################################################################
# Step 1: Install uv
################################################################################

info "Installing uv..."

if command -v uv &> /dev/null; then
    warning "uv is already installed at $(which uv)"
    CURRENT_VERSION=$(uv --version | awk '{print $2}')
    info "Current version: $CURRENT_VERSION"
    read -p "Do you want to update uv? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        info "Updating uv..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
        success "uv updated successfully"
    else
        info "Skipping uv installation"
    fi
else
    info "Installing uv via official installer..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    success "uv installed successfully"
fi

################################################################################
# Step 2: Configure Shell
################################################################################

info "Configuring shell integration..."

# Check if uv is already in shell config
UV_CONFIG_MARKER="# UV (Python) Setup"

if grep -q "$UV_CONFIG_MARKER" "$SHELL_CONFIG"; then
    warning "uv configuration already exists in $SHELL_CONFIG"
    info "Skipping shell configuration"
else
    info "Adding uv configuration to $SHELL_CONFIG"

    cat >> "$SHELL_CONFIG" << 'EOF'

# ------------------------------------
# UV (Python) Setup
# - Adds uv to PATH and enables shell completion
# ------------------------------------
export PATH="$HOME/.local/bin:$PATH"
eval "$(uv generate-shell-completion zsh 2>/dev/null || uv generate-shell-completion bash 2>/dev/null || true)"

# UV Aliases
alias uva='source .venv/bin/activate'
alias uvml='source ~/.uv-envs/ml/bin/activate'
alias uvweb='source ~/.uv-envs/web/bin/activate'
alias uvdata='source ~/.uv-envs/data/bin/activate'
EOF

    success "Shell configuration added"
fi

# Source the config to make uv available immediately
export PATH="$HOME/.local/bin:$PATH"

################################################################################
# Step 3: Install Python Versions
################################################################################

info "Installing Python versions..."

# Function to install Python if not present
install_python_version() {
    local version=$1
    if uv python list --only-installed | grep -q "cpython-$version"; then
        info "Python $version already installed"
    else
        info "Installing Python $version..."
        uv python install "$version"
        success "Python $version installed"
    fi
}

# Install common Python versions
install_python_version "3.11"
install_python_version "3.12"

info "Installed Python versions:"
uv python list --only-installed

################################################################################
# Step 4: Create Directory Structure
################################################################################

info "Creating directory structure for shared environments..."

mkdir -p "$HOME/.uv-envs"
success "Created $HOME/.uv-envs/"

################################################################################
# Step 5: Create Shared Environments (Optional)
################################################################################

read -p "Do you want to create pre-configured shared environments? (ml, web, data) [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then

    # ML Environment
    if [ -d "$HOME/.uv-envs/ml" ]; then
        warning "ML environment already exists at ~/.uv-envs/ml"
    else
        info "Creating ML environment with PyTorch, TensorFlow, and data science tools..."
        uv venv "$HOME/.uv-envs/ml" --python 3.11
        source "$HOME/.uv-envs/ml/bin/activate"
        uv pip install torch numpy pandas scikit-learn matplotlib seaborn jupyter ipykernel
        deactivate
        success "ML environment created at ~/.uv-envs/ml"
    fi

    # Web Environment
    if [ -d "$HOME/.uv-envs/web" ]; then
        warning "Web environment already exists at ~/.uv-envs/web"
    else
        info "Creating Web environment with Flask, FastAPI, and web tools..."
        uv venv "$HOME/.uv-envs/web" --python 3.12
        source "$HOME/.uv-envs/web/bin/activate"
        uv pip install flask fastapi uvicorn sqlalchemy requests httpx pydantic
        deactivate
        success "Web environment created at ~/.uv-envs/web"
    fi

    # Data Engineering Environment
    if [ -d "$HOME/.uv-envs/data" ]; then
        warning "Data environment already exists at ~/.uv-envs/data"
    else
        info "Creating Data Engineering environment..."
        uv venv "$HOME/.uv-envs/data" --python 3.11
        source "$HOME/.uv-envs/data/bin/activate"
        uv pip install pandas polars duckdb apache-airflow
        deactivate
        success "Data environment created at ~/.uv-envs/data"
    fi

else
    info "Skipping shared environments creation"
    info "You can create them later with:"
    echo "  uv venv ~/.uv-envs/ml --python 3.11"
    echo "  source ~/.uv-envs/ml/bin/activate"
    echo "  uv pip install torch pandas scikit-learn jupyter"
fi

################################################################################
# Step 6: Verification
################################################################################

info "Verifying installation..."

if command -v uv &> /dev/null; then
    UV_VERSION=$(uv --version)
    success "uv is installed: $UV_VERSION"
else
    error "uv command not found. Please restart your terminal and try again."
    exit 1
fi

################################################################################
# Summary
################################################################################

echo ""
echo "=================================="
success "UV Setup Complete!"
echo "=================================="
echo ""
echo "Installed:"
echo "  - uv $(uv --version | awk '{print $2}')"
echo "  - Python versions:"
uv python list --only-installed | sed 's/^/    /'
echo ""
echo "Configuration:"
echo "  - Shell config: $SHELL_CONFIG"
echo "  - Shared envs: $HOME/.uv-envs/"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source $SHELL_CONFIG"
echo "  2. Create a test project: uv init test-project"
echo "  3. Activate shared ML env: uvml"
echo ""
echo "Useful commands:"
echo "  uv python list          - List available Python versions"
echo "  uv venv                 - Create virtual environment"
echo "  uv add <package>        - Add package to project"
echo "  uv run python script.py - Run Python without activation"
echo ""
echo "Documentation: https://docs.astral.sh/uv/"
echo ""
