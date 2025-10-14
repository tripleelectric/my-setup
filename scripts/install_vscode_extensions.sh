#!/usr/bin/env bash
if [ -f ~/my-setup/vscode/extensions.txt ]; then
  echo "🧩 Installing VSCode extensions from list..."
  cat ~/my-setup/vscode/extensions.txt | xargs -n1 code --install-extension
else
  echo "⚠️ No extensions.txt found — skipping VSCode extensions install."
fi
