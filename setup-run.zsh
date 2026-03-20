#!/bin/zsh
set -e  # exit immediately on error
set -u  # treat unset variables as errors

echo "⚙️  Running my-setup bootstrap..."

# Ensure repo paths exist
mkdir -p ~/my-setup/scripts
mkdir -p ~/my-setup/vscode

# Symlink zsh config
ln -sf ~/my-setup/.zshrc ~/.zshrc
echo "🔗 Linked ~/.zshrc to ~/my-setup/.zshrc"

# Reload zsh configuration
if [ -f ~/.zshrc ]; then
  source ~/.zshrc
  echo "✅ Reloaded .zshrc"
else
  echo "⚠️  .zshrc not found after linking — check path!"
fi

# Configure git (user, global gitignore)
bash ~/my-setup/scripts/setup-git.sh

# Ensure VSCode CLI is available
if ! command -v code >/dev/null 2>&1; then
  echo "❌ VSCode CLI ('code') not found."
  echo "Please enable it from VSCode: Command Palette → 'Shell Command: Install 'code' command in PATH'"
  exit 1
fi

# Run cron setup script
if [ -f ~/my-setup/scripts/setup_cron_vscode_extensions.sh ]; then
  bash ~/my-setup/scripts/setup_cron_vscode_extensions.sh
else
  echo "⚠️  Missing setup_cron_vscode_extensions.sh script."
fi

bash ~/my-setup/scripts/install_vscode_extensions.sh


echo "✅ Setup complete."
