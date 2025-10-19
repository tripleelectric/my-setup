# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

# Lazy

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme


# NVM
export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# export PATH="/opt/anaconda3/bin:$PATH"  # commented out by conda initialize

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
vault() {
    VAULT_PATH="$HOME/Library/Application Support/.hidden_vault/.hidden_vault.sparseimage"
    VOLUME_NAME="SecretVault"
    VOLUME_PATH="/Volumes/$VOLUME_NAME"

    show_help() {
        echo "=== 🔐 Vault Manager ==="
        echo "Usage: vault [command] [options]"
        echo
        echo "Commands:"
        echo "  open           Mount and enter the vault (default if no command given)"
        echo "  close          Unmount the vault (force if needed)"
        echo "  toggle         Toggle vault state (open/close)"
        echo "  resize <size>  Resize the vault to a new max size (e.g. 50g, 100g)"
        echo "  help           Show this help menu"
        echo
        echo "Examples:"
        echo "  vault                # open and enter the vault"
        echo "  vault close          # close the vault safely"
        echo "  vault toggle         # switch between open/close"
        echo "  vault resize 50g     # expand vault to 50 gigabytes"
        echo
    }

    case "$1" in
        ""|"open")
            if [ ! -d "$VOLUME_PATH" ]; then
                echo "🔓 Mounting vault..."
                hdiutil attach "$VAULT_PATH" || { echo "❌ Failed to mount vault."; return 1; }
            else
                echo "✅ Vault already mounted."
            fi
            cd "$VOLUME_PATH" || { echo "❌ Failed to cd into vault."; return 1; }
            ;;
        "close")
            if [ -d "$VOLUME_PATH" ]; then
                echo "🔒 Unmounting vault..."
                cd ~
                hdiutil detach "$VOLUME_PATH" -force || { echo "❌ Failed to unmount vault."; return 1; }
            else
                echo "ℹ️ Vault is not mounted."
            fi
            ;;
        "toggle")
            if [ -d "$VOLUME_PATH" ]; then
                vault close
            else
                vault open
            fi
            ;;
        "resize")
            if [ -z "$2" ]; then
                echo "⚠️ Usage: vault resize <size>"
                echo "Example: vault resize 50g"
                return 1
            fi
            echo "📦 Resizing vault to $2..."
            hdiutil resize -size "$2" "$VAULT_PATH" || { echo "❌ Failed to resize vault."; return 1; }
            ;;
        "help")
            show_help
            ;;
        *)
            echo "❓ Unknown command: $1"
            echo "Run 'vault help' for usage."
            ;;
    esac
}


# yt-dlp Helper Functions
export YT_VAULT_PATH="$HOME/Library/Application Support/.hidden_vault/.hidden_vault.sparseimage"
export YT_VOLUME_NAME="SecretVault"

# Mount vault if not mounted
_yt_mount_vault() {
    if [ ! -d "/Volumes/$YT_VOLUME_NAME" ]; then
        echo "🔓 Mounting vault..."
        hdiutil attach "$YT_VAULT_PATH" || { echo "❌ Failed to mount vault."; return 1; }
    fi
    echo "/Volumes/$YT_VOLUME_NAME"
}

# Get destination path based on target
_yt_get_dest() {
    local target="$1"
    local default_dest="$2"

    if [[ "$target" == "vault" ]]; then
        _yt_mount_vault || return 1
    elif [[ -n "$target" ]]; then
        echo "$target"
    else
        echo "$default_dest"
    fi
}

# Get format string based on resolution
_yt_get_format() {
    local resolution="$1"

    case "$resolution" in
        "low"|"360")
            echo "bv[height<=360]+ba/best[height<=360]"
            ;;
        "medium"|"720")
            echo "bv[height<=720]+ba/best[height<=720]"
            ;;
        "high"|"best"|"1080")
            echo "bv*+ba/best"
            ;;
        *)
            echo "bv[height<=720]+ba/best[height<=720]"  # default to medium
            ;;
    esac
}

# Main download function
yt() {
    local url="$1"
    local resolution="${2:-medium}"  # default to medium
    local target="${3:-.}"           # default to current directory

    if [[ -z "$url" ]]; then
        echo "Usage: yt <url> [resolution] [target]"
        echo "Resolutions: low(360), medium(720), high(best)"
        echo "Target: vault, /path/to/folder, or . for current dir"
        return 1
    fi

    local dest
    dest="$(_yt_get_dest "$target" "$PWD")" || return 1

    local format
    format="$(_yt_get_format "$resolution")"

    echo "⬇️  Downloading to: $dest (${resolution}p)"
    yt-dlp -f "$format" -o "$dest/%(title)s.%(ext)s" "$url"
}

# Download audio only
yta() {
    local url="$1"
    local target="${2:-$HOME/Downloads}"
    local format="${3:-mp3}"

    if [[ -z "$url" ]]; then
        echo "Usage: yta <url> [target] [format]"
        echo "Formats: mp3, m4a, opus, etc."
        return 1
    fi

    local dest
    dest="$(_yt_get_dest "$target" "$HOME/Downloads")" || return 1

    echo "🎵 Downloading audio to: $dest"
    yt-dlp -x --audio-format "$format" -o "$dest/%(title)s.%(ext)s" "$url"
}

# Download playlist
ytp() {
    local url="$1"
    local resolution="${2:-medium}"
    local target="${3:-.}"

    if [[ -z "$url" ]]; then
        echo "Usage: ytp <playlist_url> [resolution] [target]"
        return 1
    fi

    local dest
    dest="$(_yt_get_dest "$target" "$PWD")" || return 1

    local format
    format="$(_yt_get_format "$resolution")"

    echo "📚 Downloading playlist to: $dest"
    yt-dlp -f "$format" \
        -o "$dest/%(playlist_title)s/%(playlist_index)03d - %(title)s.%(ext)s" \
        "$url"
}

# Download from file with links
ytf() {
    local file="${1:-links.txt}"
    local resolution="${2:-medium}"
    local target="${3:-.}"

    if [[ ! -f "$file" ]]; then
        echo "❌ File not found: $file"
        return 1
    fi

    local dest
    dest="$(_yt_get_dest "$target" "$PWD")" || return 1

    local format
    format="$(_yt_get_format "$resolution")"

    echo "📄 Downloading from $file to: $dest"
    yt-dlp -a "$file" -f "$format" -o "$dest/%(title)s.%(ext)s"
}

# Interactive downloader (simplified)
yti() {
    echo "=== Quick yt-dlp Helper ==="

    read -p "Enter URL or filename: " input
    if [[ -z "$input" ]]; then
        echo "❌ No input provided"
        return 1
    fi

    # Check if input is a file
    if [[ -f "$input" ]]; then
        ytf "$input" medium .
    else
        # It's a URL
        read -p "Video (v) or Audio (a)? [v]: " type
        type="${type:-v}"

        if [[ "$type" == "a" ]]; then
            yta "$input" .
        else
            yt "$input" medium .
        fi
    fi

    echo "✅ Download completed!"
}

# Add tab completion for the functions
_yt_completion() {
    local cur prev words cword
    _init_completion || return

    case ${prev} in
        yt|yta|ytp)
            # Complete resolutions
            COMPREPLY=($(compgen -W "low medium high" -- "${cur}"))
            ;;
        ytf)
            # Complete files
            COMPREPLY=($(compgen -f -- "${cur}"))
            ;;
        *)
            COMPREPLY=()
            ;;
    esac
}

complete -F _yt_completion yt yta ytp ytf

# Create alias for common use
alias ytdl="yt"
alias ytmusic="yta"
alias ytlist="ytf"

yth() {
    cat << EOF
🎥 yt-dlp Helper Commands - Examples

📥 BASIC DOWNLOAD:
  yt <url> [resolution] [target]
    yt "https://youtube.com/watch?v=xxx"                 # Medium quality, current dir
    yt "https://youtube.com/watch?v=xxx" high            # High quality, current dir
    yt "https://youtube.com/watch?v=xxx" medium vault    # Medium quality, vault

🎵 AUDIO ONLY:
  yta <url> [target] [format]
    yta "https://youtube.com/watch?v=xxx"                # MP3, Downloads folder
    yta "https://youtube.com/watch?v=xxx" .              # MP3, current dir
    yta "https://youtube.com/watch?v=xxx" vault opus     # Opus format, vault

📚 PLAYLISTS:
  ytp <playlist_url> [resolution] [target]
    ytp "https://youtube.com/playlist?list=xxx"          # Medium quality, current dir
    ytp "https://youtube.com/playlist?list=xxx" high "videos/vods"  # High quality, specific folder
    ytp "https://youtube.com/playlist?list=xxx" medium vault        # Medium quality, vault

📄 FROM TEXT FILES:
  ytf <file.txt> [resolution] [target]
    ytf "links.txt"                          # Medium quality, current dir
    ytf "my_links.txt" high "videos/vods"    # High quality, specific folder
    ytf "playlists.txt" medium vault         # Medium quality, vault

🎯 INTERACTIVE MODE:
  yti                                         # Guided downloader

📋 RESOLUTIONS:
  low (360p), medium (720p), high (best available)

🗂️ TARGETS:
  . (current dir), vault, or any folder path

📝 FILE FORMAT:
  Create a text file with one URL per line:
    https://youtube.com/watch?v=abc123
    https://youtube.com/watch?v=def456
    https://youtube.com/playlist?list=xyz789

💡 TIP: Use quotes around URLs with special characters!
EOF
}

# Interact with my-setup repo

# Export VSC extensions
alias vsc-export-extensions='code --list-extensions > ~/my-setup/vscode/extensions.txt && echo "✅ VSCode extensions exported"'

