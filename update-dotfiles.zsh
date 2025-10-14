cat << 'EOF' > ~/my-setup/update-dotfiles.zsh
#!/bin/zsh
set -e

echo "Updating from ~/my-setup..."
cd ~/my-setup
git pull || echo "No updates"

# Existing symlinks
ln -sf ~/my-setup/.gitignore ~/.gitignore
ln -sf ~/my-setup/.zshrc ~/.zshrc

# VS Code symlinks
mkdir -p ~/Library/Application\ Support/Code/User  # Ensure dir exists
ln -sf ~/my-setup/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -sf ~/my-setup/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
ln -sf ~/my-setup/vscode/snippets ~/Library/Application\ Support/Code/User/snippets  # If using snippets

source ~/.zshrc
echo "✅ Updated!"
EOF
