#!/bin/zsh
set -e

echo "Updating from ~/my-setup..."
if [ ! -d ~/my-setup ]; then
    echo "Error: ~/my-setup directory not found!"
    exit 1
fi

cd ~/my-setup
git pull || echo "No updates"

# Core dotfiles
ln -sf ~/my-setup/.zshrc ~/.zshrc
[ -f ~/my-setup/.p10k.zsh ] && ln -sf ~/my-setup/.p10k.zsh ~/.p10k.zsh

# VS Code symlinks
mkdir -p ~/Library/Application\ Support/Code/User
ln -sf ~/my-setup/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -sf ~/my-setup/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
[ -d ~/my-setup/vscode/snippets ] && ln -sf ~/my-setup/vscode/snippets ~/Library/Application\ Support/Code/User/snippets

# iTerm2 symlink
[ -f ~/my-setup/iterm/com.googlecode.iterm2.plist ] && ln -sf ~/my-setup/iterm/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist

source ~/.zshrc
echo "✅ Updated!"
