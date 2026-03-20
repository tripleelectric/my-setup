#!/bin/bash
set -e
set -u

echo "⚙️  Configuring git..."

# Set user identity (prompt if not already configured)
current_name=$(git config --global user.name 2>/dev/null || echo "")
current_email=$(git config --global user.email 2>/dev/null || echo "")

if [ -n "$current_name" ] && [ -n "$current_email" ]; then
  echo "Git user already configured: $current_name <$current_email>"
  read -rp "Keep this? (y/n) " keep
  if [ "$keep" != "y" ]; then
    current_name=""
    current_email=""
  fi
fi

if [ -z "$current_name" ]; then
  read -rp "Enter git user.name: " current_name
  git config --global user.name "$current_name"
fi

if [ -z "$current_email" ]; then
  read -rp "Enter git user.email: " current_email
  git config --global user.email "$current_email"
fi

echo "✅ Git user: $current_name <$current_email>"

# Copy global gitignore and configure git to use it
cp ~/my-setup/.gitignore_global ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global
echo "✅ Installed global gitignore at ~/.gitignore_global"

# Function to pull default .gitignore to the current directory
pull() {
  if [[ "$1" == "gi" ]]; then
    cp ~/my-setup/.gitignore .
    echo "✅ .gitignore copied to $(pwd)"
  else
    echo "Usage: pull gi"
  fi
}
