#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

# Dependency checks
for cmd in curl git; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: '$cmd' is required but not installed." >&2
        exit 1
    fi
done

# Install Zsh if not present
if ! command -v zsh >/dev/null 2>&1; then
    echo "Installing Zsh..."
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update && sudo apt-get install -y zsh
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y zsh
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --noconfirm zsh
    else
        echo "Error: Could not detect package manager. Install zsh manually." >&2
        exit 1
    fi
fi

# Install Oh My Zsh
if [ ! -d "$HOME_DIR/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Powerlevel10k theme
P10K_DIR="$HOME_DIR/.oh-my-zsh/custom/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    echo "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

# Install Zsh plugins
ZSH_PLUGINS_DIR="$HOME_DIR/.oh-my-zsh/custom/plugins"

if [ ! -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS_DIR/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"
fi

# Backup and symlink configuration files
echo "Applying configuration files..."

link_file() {
    local src="$1"
    local dest="$2"
    if [ -f "$dest" ] && [ ! -L "$dest" ]; then
        echo "  Backing up $dest -> ${dest}.bak"
        cp "$dest" "${dest}.bak"
    fi
    ln -sf "$src" "$dest"
    echo "  Linked $src -> $dest"
}

link_file "$SCRIPT_DIR/.zshrc" "$HOME_DIR/.zshrc"
link_file "$SCRIPT_DIR/.p10k.zsh" "$HOME_DIR/.p10k.zsh"
link_file "$SCRIPT_DIR/.gitconfig" "$HOME_DIR/.gitconfig"
link_file "$SCRIPT_DIR/.aliases" "$HOME_DIR/.aliases"
link_file "$SCRIPT_DIR/.exports" "$HOME_DIR/.exports"
