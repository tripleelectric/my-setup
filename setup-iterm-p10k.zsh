#!/bin/zsh
#
# SCRIPT: setup_terminal.zsh
# DESCRIPTION: Automates the installation of Homebrew, iTerm2, Oh My Zsh,
#              Powerlevel10k, and the required Meslo Nerd Font on macOS.
#

# --- Function to check if a command exists ---
command_exists () {
  command -v "$1" >/dev/null 2>&1
}

echo "****************************************************************"
echo "        💻 Starting iTerm2 and Powerlevel10k Setup             "
echo "****************************************************************"

# --- 1. Install Homebrew (if not installed) ---
if ! command_exists brew; then
    echo "⬇️ Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL 
https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for the rest of the script
    if [[ "$(uname -m)" == "arm64" ]]; then
        # Apple Silicon path
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        # Intel path
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    echo "✅ Homebrew installed."
else
    echo "✅ Homebrew already installed. Updating..."
    brew update
fi

# --- 2. Install iTerm2 and MesloLGS Nerd Font ---
echo "⬇️ Installing iTerm2 and MesloLGS NF (required Powerlevel10k 
font)..."

# Tap the font cask repository if not tapped (prevents errors)
brew tap homebrew/cask-fonts

# Install iTerm2 (if not already installed)
if ! brew list --cask | grep -q "iterm2"; then
    brew install --cask iterm2
    echo "✅ iTerm2 installed."
else
    echo "✅ iTerm2 already installed."
fi

# Install the MesloLGS Nerd Font (required for Powerlevel10k symbols)
if ! brew list --cask | grep -q "font-meslo-lg-nerd-font"; then
    brew install --cask font-meslo-lg-nerd-font
    echo "✅ MesloLGS NF Font installed."
else
    echo "✅ MesloLGS NF Font already installed."
fi


# --- 3. Install Oh My Zsh (if not installed) ---
ZSH_DIR="$HOME/.oh-my-zsh"
if [[ ! -d "$ZSH_DIR" ]]; then
    echo "⬇️ Oh My Zsh not found. Installing Oh My Zsh..."
    
    # Use the non-interactive install to prevent setting Zsh as default 
shell immediately
    # We will handle shell changes separately to be cleaner
    sh -c "$(curl -fsSL 
https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 
"" --unattended

    # The installer may prompt to change default shell, but the 
'--unattended' flag should prevent it.
    echo "✅ Oh My Zsh installed."
else
    echo "✅ Oh My Zsh already installed."
fi


# --- 4. Install Powerlevel10k Theme ---
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [[ ! -d "$P10K_DIR" ]]; then
    echo "⬇️ Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git 
"$P10K_DIR"
    echo "✅ Powerlevel10k installed."
else
    echo "✅ Powerlevel10k already installed."
fi


# --- 5. Configure ~/.zshrc for Powerlevel10k ---
ZSHRC_FILE="$HOME/.zshrc"

echo "⚙️ Configuring ~/.zshrc to use Powerlevel10k..."

# Use sed to replace the default theme with powerlevel10k
# Note: The 'sed -i' usage is specific to macOS/BSD, needing the empty 
string '' after -i
# The '/' in the theme name is escaped as '\/'
sed -i '' 's/ZSH_THEME="[^"]*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' 
"$ZSHRC_FILE"

# Ensure the Powerlevel10k theme is correctly set (e.g., if ZSH_THEME line 
was missing)
if ! grep -q 'ZSH_THEME="powerlevel10k/powerlevel10k"' "$ZSHRC_FILE"; then
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$ZSHRC_FILE"
fi

echo "✅ ~/.zshrc updated."

# --- 6. Set Zsh as Default Shell (if not already) ---
if [[ "$SHELL" != "$(which zsh)" ]]; then
    echo "🐚 Setting Zsh as the default shell..."
    chsh -s "$(which zsh)"
    echo "✅ Default shell set to Zsh."
else
    echo "✅ Zsh is already the default shell."
fi

echo "****************************************************************"
echo "🎉 SETUP COMPLETE! Please read the next steps below. "
echo "****************************************************************"

# --- Next Steps Instructions ---
echo "--- IMPORTANT NEXT STEPS ---"
echo "1. **Restart iTerm2:** You MUST close and re-open iTerm2 (or open a 
new tab/window)."
echo "2. **Set the Font:** Go to iTerm2 > Preferences > Profiles > Text > 
Font."
echo "   Select **'MesloLGS NF'** to ensure symbols render correctly."
echo "3. **Configure P10K:** When you open a new iTerm2 window, the 
Powerlevel10k configuration wizard should start automatically."
echo "   If it does not, simply run the command: \`p10k configure\`"
echo "4. **Review .zshrc:** Review your new ~/.zshrc file to add plugins, 
aliases, or other configurations."
