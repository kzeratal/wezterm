#!/bin/zsh

# Script to symlink this wezterm config to ~/.config/wezterm

SCRIPT_DIR="${0:A:h}"
CONFIG_DIR="$HOME/.config/wezterm"

# Create ~/.config directory if it doesn't exist
mkdir -p "$HOME/.config"

# Remove existing config if it exists
if [[ -e "$CONFIG_DIR" ]]; then
    echo "Removing existing config at $CONFIG_DIR"
    rm -rf "$CONFIG_DIR"
fi

# Create symlink
echo "Creating symlink from $SCRIPT_DIR to $CONFIG_DIR"
ln -s "$SCRIPT_DIR" "$CONFIG_DIR"

echo "Wezterm config successfully linked to ~/.config/wezterm"