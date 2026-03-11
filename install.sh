#!/bin/bash

# Define the home directory path
HOME_DIR=$HOME

# Update system and install Zsh if it's not already present
if ! command -v zsh >/dev/null 2>&1; then
    echo "Installing Zsh..."
    sudo apt-get update && sudo apt-get install -y zsh
fi

# Install Oh My Zsh (unattended mode to avoid manual prompts)
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

# Install Zsh plugins (autosuggestions and syntax highlighting)
ZSH_PLUGINS_DIR="$HOME_DIR/.oh-my-zsh/custom/plugins"

if [ ! -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS_DIR/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"
fi

# Copy configuration files from the repository to the container's home directory
echo "Applying configuration files..."
cp .zshrc "$HOME_DIR/.zshrc"
cp .p10k.zsh "$HOME_DIR/.p10k.zsh"
cp .gitconfig "$HOME_DIR/.gitconfig"

echo "✅ Setup complete! Enjoy your terminal."