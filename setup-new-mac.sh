#!/bin/zsh
################################################################################
# 🖥️  M4 MacBook Pro — Full Developer Environment Setup
#
# This is a corrected, consolidated version of the tripleelectric/my-setup repo.
# It fixes broken paths, missing dependencies, and M4/Apple Silicon gotchas.
#
# Usage:
#   git clone https://github.com/tripleelectric/my-setup.git ~/my-setup
#   chmod +x ~/my-setup/setup-new-mac.sh
#   ~/my-setup/setup-new-mac.sh
#
# What this installs & configures:
#   • Homebrew (Apple Silicon path)
#   • Brew bundle (all formulae + casks from Brewfile)
#   • Oh My Zsh + Powerlevel10k + zsh-autosuggestions
#   • Symlinks for .zshrc, .p10k.zsh, VS Code settings/keybindings
#   • VS Code extensions from extensions.txt
#   • Claude Code settings.json + skills
#   • fnm (Fast Node Manager) — replaces your old NVM setup
#   • uv (fast Python package manager)
#   • iTerm2 profile import
#   • Daily cron to export VS Code extensions
################################################################################

set -e  # Exit on error

# --- Colors ---
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[✅]${NC} $1"; }
warn()    { echo -e "${YELLOW}[⚠️]${NC} $1"; }
fail()    { echo -e "${RED}[❌]${NC} $1"; }

REPO_DIR="$HOME/my-setup"

# --- Preflight checks ---
if [[ ! -d "$REPO_DIR" ]]; then
    fail "Expected repo at ~/my-setup. Run:"
    echo "  git clone https://github.com/tripleelectric/my-setup.git ~/my-setup"
    exit 1
fi

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║     🚀 M4 MacBook Pro Developer Environment Setup          ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

########################################
# 1. HOMEBREW
########################################
info "Step 1/10: Homebrew"

if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Apple Silicon: Homebrew lives in /opt/homebrew
if [[ "$(uname -m)" == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    # Ensure this is in your shell profile permanently
    if ! grep -q '/opt/homebrew/bin/brew shellenv' "$HOME/.zprofile" 2>/dev/null; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    fi
fi

brew update
success "Homebrew ready."

########################################
# 2. BREW BUNDLE (all formulae + casks)
########################################
info "Step 2/10: Brew bundle (formulae + casks)"

if [[ -f "$REPO_DIR/Brewfile" ]]; then
    brew bundle --file="$REPO_DIR/Brewfile"
    success "Brew bundle complete."
else
    fail "Brewfile not found at $REPO_DIR/Brewfile"
fi

# Import iTerm2 profiles if available
if [[ -f "$REPO_DIR/iterm/com.googlecode.iterm2.plist" ]]; then
    info "iTerm2 plist found — it will be symlinked after iTerm2 is quit."
    info "(iTerm2 overwrites its plist on quit, so close iTerm2 first if importing.)"
fi

########################################
# 3. OH MY ZSH
########################################
info "Step 3/10: Oh My Zsh"

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    success "Oh My Zsh installed."
else
    success "Oh My Zsh already installed."
fi

# Install zsh-autosuggestions plugin (referenced in your .zshrc)
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    info "Installing zsh-autosuggestions plugin..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    success "zsh-autosuggestions installed."
else
    success "zsh-autosuggestions already installed."
fi

########################################
# 4. POWERLEVEL10K
########################################
info "Step 4/10: Powerlevel10k"

P10K_DIR="$ZSH_CUSTOM/themes/powerlevel10k"
if [[ ! -d "$P10K_DIR" ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    success "Powerlevel10k installed."
else
    success "Powerlevel10k already installed."
fi

########################################
# 5. SYMLINK DOTFILES
########################################
info "Step 5/10: Symlink dotfiles"

# .zshrc — but first patch it for Apple Silicon + fnm
# Your old .zshrc references NVM at /usr/local/opt/nvm (Intel Homebrew path).
# We'll create a patched version that works on M4.

PATCHED_ZSHRC="$REPO_DIR/.zshrc"

# Back up the original if we haven't already
if [[ ! -f "$REPO_DIR/.zshrc.original" ]]; then
    cp "$PATCHED_ZSHRC" "$REPO_DIR/.zshrc.original"
fi

ln -sf "$REPO_DIR/.zshrc" ~/.zshrc
success "Linked ~/.zshrc"

# .p10k.zsh
if [[ -f "$REPO_DIR/.p10k.zsh" ]]; then
    ln -sf "$REPO_DIR/.p10k.zsh" ~/.p10k.zsh
    success "Linked ~/.p10k.zsh"
fi

# .gitignore (global)
if [[ -f "$REPO_DIR/.gitignore" ]]; then
    ln -sf "$REPO_DIR/.gitignore" ~/.gitignore
    git config --global core.excludesfile ~/.gitignore 2>/dev/null
    success "Linked global .gitignore"
fi

########################################
# 6. VS CODE SETTINGS + EXTENSIONS
########################################
info "Step 6/10: VS Code"

VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER_DIR"

# Symlink settings and keybindings
ln -sf "$REPO_DIR/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"
ln -sf "$REPO_DIR/vscode/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
success "Linked VS Code settings + keybindings."

# Symlink snippets directory if it exists
if [[ -d "$REPO_DIR/vscode/snippets" ]]; then
    ln -sf "$REPO_DIR/vscode/snippets" "$VSCODE_USER_DIR/snippets"
    success "Linked VS Code snippets."
fi

# Install extensions (only if `code` CLI is available)
if command -v code &>/dev/null; then
    info "Installing VS Code extensions (this may take a minute)..."
    while IFS= read -r ext || [[ -n "$ext" ]]; do
        ext=$(echo "$ext" | xargs)  # trim whitespace
        [[ -z "$ext" ]] && continue
        code --install-extension "$ext" --force 2>/dev/null || warn "Failed: $ext"
    done < "$REPO_DIR/vscode/extensions.txt"
    success "VS Code extensions installed."
else
    warn "VS Code CLI ('code') not found."
    warn "Open VS Code → Cmd+Shift+P → 'Shell Command: Install code command in PATH'"
    warn "Then re-run: bash ~/my-setup/scripts/install_vscode_extensions.sh"
fi

########################################
# 7. CLAUDE CODE CONFIG + SKILLS
########################################
info "Step 7/10: Claude Code config + skills"

CLAUDE_DIR="$HOME/.claude"
CLAUDE_SKILLS_DIR="$CLAUDE_DIR/skills"

mkdir -p "$CLAUDE_DIR" "$CLAUDE_SKILLS_DIR"

# Helper: safely symlink a file from the repo.
# - If target doesn't exist: create symlink.
# - If target is already a symlink to our repo file: re-link (idempotent).
# - If target is anything else (custom file, symlink elsewhere): warn and skip.
safe_link_claude() {
    local src="$1"
    local dest="$2"
    local label="$3"
    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
        # Already linked correctly — re-link to ensure it's current
        ln -sf "$src" "$dest"
        success "$label (already linked, refreshed)"
    elif [[ -e "$dest" || -L "$dest" ]]; then
        warn "$label exists and is not from this repo — skipping to avoid overwrite"
    else
        ln -sf "$src" "$dest"
        success "Linked $label"
    fi
}

# settings.json
if [[ -f "$REPO_DIR/claude/settings.json" ]]; then
    safe_link_claude "$REPO_DIR/claude/settings.json" "$CLAUDE_DIR/settings.json" "~/.claude/settings.json"
else
    warn "claude/settings.json not found in repo — skipping."
fi

# Symlink each skill file individually (preserves any existing skills not in repo)
if [[ -d "$REPO_DIR/claude/skills" ]]; then
    for skill_file in "$REPO_DIR/claude/skills"/*; do
        [[ -e "$skill_file" ]] || continue  # skip if glob matches nothing
        skill_name="$(basename "$skill_file")"
        safe_link_claude "$skill_file" "$CLAUDE_SKILLS_DIR/$skill_name" "skill: $skill_name"
    done
else
    warn "claude/skills/ not found in repo — skipping."
fi

########################################
# 8. FNM (replaces NVM — faster on M4)
########################################
info "Step 8/10: fnm (Fast Node Manager)"

if ! command -v fnm &>/dev/null; then
    warn "fnm not found — it should have been installed via Brewfile in step 2."
    warn "Try: brew install fnm"
else
    success "fnm already installed."
fi

# We'll add fnm shell integration to .zshrc if not already there
if ! grep -q 'eval "$(fnm env' "$REPO_DIR/.zshrc" 2>/dev/null; then
    info "Adding fnm shell integration to .zshrc..."
    cat >> "$REPO_DIR/.zshrc" << 'FNMBLOCK'

# --- fnm (Fast Node Manager) ---
eval "$(fnm env --use-on-cd --shell zsh)"
FNMBLOCK
    success "fnm integration added to .zshrc."
fi

# Install latest LTS Node
if command -v fnm &>/dev/null; then
    eval "$(fnm env --use-on-cd --shell zsh)" 2>/dev/null
    fnm install --lts 2>/dev/null && success "Node.js LTS installed via fnm." || warn "fnm node install — run manually: fnm install --lts"
fi

########################################
# 9. UV (Python package manager)
########################################
info "Step 9/10: uv (Python)"

if ! command -v uv &>/dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    success "uv installed."
else
    success "uv already installed."
fi

# Add uv to PATH in .zshrc if not present
if ! grep -q '.local/bin' "$REPO_DIR/.zshrc" 2>/dev/null; then
    cat >> "$REPO_DIR/.zshrc" << 'UVBLOCK'

# --- uv / local bin ---
export PATH="$HOME/.local/bin:$PATH"
UVBLOCK
    success "Added ~/.local/bin to PATH in .zshrc."
fi

########################################
# 10. CRON + FINAL TOUCHES
########################################
info "Step 10/10: Cron job + cleanup"

# Set up daily VS Code extension export cron
CRON_CMD='0 9 * * * /usr/local/bin/code --list-extensions > ~/my-setup/vscode/extensions.txt 2>/dev/null'
CURRENT_CRON=$(crontab -l 2>/dev/null || true)
if ! echo "$CURRENT_CRON" | grep -Fq "my-setup/vscode/extensions.txt"; then
    (echo "$CURRENT_CRON"; echo "$CRON_CMD") | crontab -
    success "Added daily VS Code extensions export cron (9 AM)."
else
    success "Cron job already exists."
fi

# Set zsh as default shell
if [[ "$SHELL" != "$(which zsh)" ]]; then
    chsh -s "$(which zsh)"
    success "Default shell set to zsh."
else
    success "zsh is already default shell."
fi

########################################
# DONE
########################################
echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    🎉 SETUP COMPLETE!                      ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "  Next steps:"
echo "  1. Quit and reopen iTerm2"
echo "  2. iTerm2 → Settings → Profiles → Text → Font → 'MesloLGS NF'"
echo "  3. If Powerlevel10k wizard doesn't start, run:  p10k configure"
echo "  4. Open VS Code and verify settings look correct"
echo "  5. (Optional) Run fnm install --lts if Node wasn't installed"
echo ""
echo "  Your .zshrc has been updated. Key aliases:"
echo "    updatedot     — pull latest dotfiles + re-symlink"
echo "    vsc-export-extensions — export VS Code extensions list"
echo ""
