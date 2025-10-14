cat << 'EOF' > ~/my-setup/vscode/install-extensions.zsh
#!/bin/zsh
while read ext; do
    code --install-extension $ext
done < ~/my-setup/vscode/extensions.txt
echo "Extensions installed!"
EOF
chmod +x ~/my-setup/vscode/install-extensions.zsh
