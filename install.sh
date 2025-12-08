#!/bin/bash

# install.sh - Setup script for Neovim configuration in devcontainers
# This script creates a symlink from the cloned repository to ~/.config/nvim

set -e

# Get the directory where this script is located (the repo root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
NVIM_CONFIG="$CONFIG_DIR/nvim"

echo "Setting up Neovim configuration..."
echo "Repository location: $SCRIPT_DIR"
echo "Target location: $NVIM_CONFIG"

# Create ~/.config directory if it doesn't exist
if [ ! -d "$CONFIG_DIR" ]; then
    echo "Creating $CONFIG_DIR directory..."
    mkdir -p "$CONFIG_DIR"
fi

# Handle existing nvim configuration
if [ -e "$NVIM_CONFIG" ]; then
    if [ -L "$NVIM_CONFIG" ]; then
        # It's already a symlink
        CURRENT_TARGET="$(readlink -f "$NVIM_CONFIG")"
        if [ "$CURRENT_TARGET" = "$SCRIPT_DIR" ]; then
            echo "Symlink already points to this repository. Nothing to do."
            exit 0
        else
            echo "Removing existing symlink pointing to: $CURRENT_TARGET"
            rm "$NVIM_CONFIG"
        fi
    else
        # It's a regular directory or file - back it up
        BACKUP="$NVIM_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Backing up existing configuration to: $BACKUP"
        mv "$NVIM_CONFIG" "$BACKUP"
    fi
fi

# Create the symlink
echo "Creating symlink: $NVIM_CONFIG -> $SCRIPT_DIR"
ln -s "$SCRIPT_DIR" "$NVIM_CONFIG"

echo "✓ Neovim configuration setup complete!"
echo ""
echo "Next steps:"
echo "  1. Run 'nvim' to start Neovim"
echo "  2. Plugins will install automatically on first launch"
echo "  3. Run ':checkhealth' to verify the setup"
