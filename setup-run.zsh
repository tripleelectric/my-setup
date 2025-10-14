cat << 'EOF' > ~/my-setup/setup.zsh
#!/bin/zsh
ln -sf ~/my-setup/.gitignore ~/.gitignore
ln -sf ~/my-setup/.zshrc ~/.zshrc
source ~/.zshrc
echo "Dotfiles setup complete"
EOF
chmod +x ~/my-setup/setup.zsh
