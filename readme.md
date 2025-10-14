# My-Setup Dotfiles

This repository manages my personal dotfiles for zsh, Powerlevel10k, VS Code, and related tools. It uses symlinks to keep configurations synced across machines.

## Repository Structure

- `.zshrc`: Main zsh configuration, including Powerlevel10k and aliases (e.g., `updatedot`).
- `.p10k.zsh`: Powerlevel10k prompt configuration for zsh.
- `.gitignore`: Standard gitignore file for repositories.
- `vscode/`: VS Code configurations.
  - `settings.json`: VS Code user settings.
  - `keybindings.json`: Custom keybindings.
  - `snippets/`: Custom code snippets (optional).
  - `extensions.txt`: List of installed VS Code extensions.
  - `install-extensions.zsh`: Script to install VS Code extensions.
- `iterm/`: iTerm2 configuration (optional).
  - `com.googlecode.iterm2.plist`: iTerm2 preferences.
- `update-dotfiles.zsh`: Script to pull updates from this repo and reapply symlinks.
- `setup-run.zsh`: Script to set up dotfiles on a new machine.

## Prerequisites

- **macOS** (adjust paths for Linux/Windows).
- **zsh**: Default shell (run `chsh -s /bin/zsh` if needed).
- **git**: For cloning and managing the repo.
- **VS Code**: For applying editor configs.
- **iTerm2** (optional): For terminal customizations.
- **curl**: For installing dependencies.

## Setup Instructions

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/tripleelectric/my-setup.git ~/my-setup
   ```

2. **Run the Setup Script**:
   ```bash
   cd ~/my-setup
   chmod +x setup.zsh
   ./setup.zsh
   ```
   This:
   - Creates symlinks for `.zshrc`, `.p10k.zsh`, `.gitignore`, and VS Code configs.
   - Installs VS Code extensions from `vscode/extensions.txt`.
   - Sets up iTerm2 preferences (if included).
   - Sources `~/.zshrc` to apply changes.

3. **Install Powerlevel10k** (if not already installed):
   ```bash
   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
   ```
   Run the configurator if you want to customize the prompt:
   ```bash
   p10k configure
   ```
   Move the generated `~/.p10k.zsh` to the repo:
   ```bash
   mv ~/.p10k.zsh ~/my-setup/.p10k.zsh
   ln -sf ~/my-setup/.p10k.zsh ~/.p10k.zsh
   ```

4. **Grant Permissions** (macOS):
   - Go to **System Settings > Privacy & Security > Full Disk Access**.
   - Enable access for iTerm2 and VS Code.

5. **Verify Setup**:
   - Open a new iTerm2 session to check Powerlevel10k prompt.
   - Open VS Code and verify settings/keybindings/snippets.
   - Check symlinks:
     ```bash
     ls -la ~ | grep -E 'zshrc|p10k|gitignore'
     ls -la ~/Library/Application\ Support/Code/User/
     ```

## Usage

- **Update Dotfiles**:
  Run `updatedot` to pull the latest changes from the repo and reapply symlinks:
  ```bash
  updatedot
  ```

- **Install VS Code Extensions**:
  ```bash
  ~/my-setup/vscode/install-extensions.zsh
  ```

- **Add New Configs**:
  - Place new dotfiles (e.g., `.vimrc`) in `~/my-setup`.
  - Update `setup.zsh` and `update-dotfiles.zsh` to symlink them.
  - Commit and push:
    ```bash
    cd ~/my-setup
    git add .
    git commit -m "Add new config"
    git push
    ```

## Troubleshooting

- **Powerlevel10k Not Loading**:
  Ensure `~/.powerlevel10k` exists and `~/.zshrc` sources it. Re-run `p10k configure` if needed.
- **VS Code Configs Not Applying**:
  Check symlinks in `~/Library/Application Support/Code/User`. Ensure VS Code has full disk access.
- **Permission Errors**:
  Run `sudo chmod -R u+rw ~/Library/Application\ Support/Code/User` or grant full disk access in System Settings.
- **Restore Backup**:
  If something breaks, restore from backups in `~/my-setup/backups` (if created).

## Contributing

This is a personal setup repo, but feel free to fork and adapt! Submit issues/PRs to [github.com/tripleelectric/my-setup](https://github.com/tripleelectric/my-setup).
