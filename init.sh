#!/usr/bin/env bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Setting up NixOS dotfiles..."

echo "Creating symlink for NixOS configuration..."
sudo ln -sf "$DOTFILES_DIR/nixos/configuration.nix" /etc/nixos/configuration.nix

echo "Creating ~/.config directory if it doesn't exist..."
mkdir -p ~/.config

echo "Creating symlink for Hyprland configuration..."
ln -sf "$DOTFILES_DIR/hypr" ~/.config/

echo "Dotfiles setup complete!"
echo "You can now run 'sudo nixos-rebuild switch' to apply the configuration."
