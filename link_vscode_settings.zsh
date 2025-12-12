#!/bin/zsh
#
# SCRIPT: link_vscode_settings.zsh
# DESCRIPTION: Creates a symbolic link for VS Code's user settings
#              to point to a centralized settings.json in the setup repository.
#

# --- Variables ---
# The location of the settings file in your setup repository
REPO_SETTINGS_FILE="$HOME/my-setup/vscode/settings.json"

# --- 1. Identify Target Location based on OS ---
# Use 'uname' to detect the operating system
case $(uname) in
    Darwin)
        # macOS
        VSCODE_SETTINGS_DIR="$HOME/Library/Application Support/Code/User"
        ;;
    Linux)
        # Linux (e.g., Ubuntu, Fedora)
        VSCODE_SETTINGS_DIR="$HOME/.config/Code/User"
        ;;
    *)
        echo "❌ ERROR: Unsupported OS detected."
        exit 1
        ;;
esac

VSCODE_TARGET_PATH="$VSCODE_SETTINGS_DIR/settings.json"

echo "✅ Detected Settings Path: $VSCODE_TARGET_PATH"
echo "➡️ Source Settings Path: $REPO_SETTINGS_FILE"

# --- 2. Check Prerequisites ---
if [[ ! -f "$REPO_SETTINGS_FILE" ]]; then
    echo "❌ ERROR: Source settings file not found at $REPO_SETTINGS_FILE"
    echo "         Please ensure this file exists before running the script."
    exit 1
fi

if [[ ! -d "$VSCODE_SETTINGS_DIR" ]]; then
    echo "⚠️ WARNING: VS Code User directory not found at $VSCODE_SETTINGS_DIR. Attempting to create it..."
    # Attempt to create the directory if it doesn't exist
    mkdir -p "$VSCODE_SETTINGS_DIR"
    if [[ $? -ne 0 ]]; then
        echo "❌ ERROR: Failed to create VS Code settings directory."
        exit 1
    fi
fi

# --- 3. Backup/Remove Existing File or Link ---
if [[ -f "$VSCODE_TARGET_PATH" || -L "$VSCODE_TARGET_PATH" ]]; then
    echo "⚠️ Existing settings.json or symbolic link found. Backing up and removing..."
    if [[ -f "$VSCODE_TARGET_PATH" ]]; then
        # Backup the actual file
        mv "$VSCODE_TARGET_PATH" "$VSCODE_TARGET_PATH.bak"
        echo "    -> Backed up to: $VSCODE_TARGET_PATH.bak"
    else
        # If it's a symlink, just remove the link itself
        rm "$VSCODE_TARGET_PATH"
        echo "    -> Removed existing symbolic link."
    fi
fi

# --- 4. Create the Symbolic Link ---
echo "🔗 Creating symbolic link..."
# ln -s [SOURCE_FILE] [LINK_LOCATION]
ln -s "$REPO_SETTINGS_FILE" "$VSCODE_TARGET_PATH"

if [[ $? -eq 0 ]]; then
    echo "🎉 SUCCESS! VS Code user settings successfully linked."
    echo "   $VSCODE_TARGET_PATH now points to $REPO_SETTINGS_FILE"
else
    echo "❌ ERROR: Failed to create symbolic link."
    exit 1
fi