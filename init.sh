#!/usr/bin/env bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Setting up NixOS dotfiles..."

echo "Handling hardware-configuration.nix..."
if [ -f "/etc/nixos/hardware-configuration.nix" ] && [ ! -f "$DOTFILES_DIR/nixos/hardware-configuration.nix" ]; then
    echo "Moving hardware-configuration.nix to dotfiles repo..."
    sudo cp /etc/nixos/hardware-configuration.nix "$DOTFILES_DIR/nixos/"
    sudo chown $USER:$USER "$DOTFILES_DIR/nixos/hardware-configuration.nix"
fi

echo "Creating symlink for NixOS configuration..."
sudo ln -sf "$DOTFILES_DIR/nixos/configuration.nix" /etc/nixos/configuration.nix

echo "Creating ~/.config directory if it doesn't exist..."
mkdir -p ~/.config

echo "Creating symlink for Hyprland configuration..."
ln -sf "$DOTFILES_DIR/hypr" ~/.config/

echo "Dotfiles setup complete!"
echo "You can now run 'sudo nixos-rebuild switch' to apply the configuration."
