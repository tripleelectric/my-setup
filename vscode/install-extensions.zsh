#!/bin/zsh
while read ext; do
    code --install-extension $ext
done < ~/my-setup/vscode/extensions.txt
echo "Extensions installed!"
