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

echo "Creating symlinks for config folders to ~/.config/..."
for config_dir in "$DOTFILES_DIR/config"/*; do
    if [ -d "$config_dir" ]; then
        config_name=$(basename "$config_dir")
        echo "Symlinking $config_name to ~/.config/..."
        ln -sf "$config_dir" ~/.config/
    fi
done

echo "Creating symlinks for root config files to ~/..."
if [ -d "$DOTFILES_DIR/root_config" ]; then
    for root_config_folder in "$DOTFILES_DIR/root_config"/*; do
        if [ -d "$root_config_folder" ]; then
            folder_name=$(basename "$root_config_folder")
            echo "Processing $folder_name folder..."

            for file in "$root_config_folder"/*; do
                if [ -f "$file" ]; then
                    filename=$(basename "$file")
                    echo "  Symlinking $filename to ~/.$filename"
                    ln -sf "$file" ~/."$filename"
                fi
            done
        fi
    done
fi

echo "Creating symlink for legacy hypr folder (if exists)..."
if [ -d "$DOTFILES_DIR/hypr" ]; then
    ln -sf "$DOTFILES_DIR/hypr" ~/.config/
fi

echo "Setting up tmux plugin manager (TPM)..."
if [ ! -d ~/.tmux/plugins/tpm ]; then
    echo "Cloning TPM..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "TPM already installed"
fi

echo "Dotfiles setup complete!"
echo ""
echo "Next steps:"
echo "1. Run 'sudo nixos-rebuild switch' to apply the NixOS configuration"
echo "2. Start tmux and press 'Ctrl+s + I' to install tmux plugins"
echo "3. Reload tmux config with 'Ctrl+s + r'"
