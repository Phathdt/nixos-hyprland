#!/usr/bin/env bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Setting up NixOS dotfiles with full automation..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Handle hardware-configuration.nix
print_status "Handling hardware-configuration.nix..."
if [ -f "/etc/nixos/hardware-configuration.nix" ] && [ ! -f "$DOTFILES_DIR/nixos/hardware-configuration.nix" ]; then
    print_status "Moving hardware-configuration.nix to dotfiles repo..."
    sudo cp /etc/nixos/hardware-configuration.nix "$DOTFILES_DIR/nixos/"
    sudo chown $USER:$USER "$DOTFILES_DIR/nixos/hardware-configuration.nix"
    print_success "Hardware configuration moved"
fi

# Create NixOS symlink
print_status "Creating symlink for NixOS configuration..."
sudo ln -sf "$DOTFILES_DIR/nixos/configuration.nix" /etc/nixos/configuration.nix
print_success "NixOS configuration linked"

# Create ~/.config directory
print_status "Creating ~/.config directory..."
mkdir -p ~/.config

# Symlink config folders
print_status "Creating symlinks for config folders to ~/.config/..."
for config_dir in "$DOTFILES_DIR/config"/*; do
    if [ -d "$config_dir" ]; then
        config_name=$(basename "$config_dir")
        print_status "Symlinking $config_name to ~/.config/..."
        ln -sf "$config_dir" ~/.config/
    fi
done
print_success "Config folders linked"

# Symlink root config files
print_status "Creating symlinks for root config files to ~/..."
if [ -d "$DOTFILES_DIR/root_config" ]; then
    for root_config_folder in "$DOTFILES_DIR/root_config"/*; do
        if [ -d "$root_config_folder" ]; then
            folder_name=$(basename "$root_config_folder")
            print_status "Processing $folder_name folder..."

            for file in "$root_config_folder"/*; do
                if [ -f "$file" ]; then
                    filename=$(basename "$file")
                    print_status "  Symlinking $filename to ~/.$filename"
                    ln -sf "$file" ~/."$filename"
                fi
            done
        fi
    done
fi
print_success "Root config files linked"

# Legacy hypr folder support
if [ -d "$DOTFILES_DIR/hypr" ]; then
    print_status "Creating symlink for legacy hypr folder..."
    ln -sf "$DOTFILES_DIR/hypr" ~/.config/
    print_success "Legacy hypr folder linked"
fi

# Install zplug
print_status "Setting up zplug..."
if [ ! -d ~/.zplug ]; then
    print_status "Installing zplug..."
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
    print_success "zplug installed"
else
    print_warning "zplug already installed"
fi

# Install TPM (Tmux Plugin Manager)
print_status "Setting up tmux plugin manager (TPM)..."
if [ ! -d ~/.tmux/plugins/tpm ]; then
    print_status "Cloning TPM..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    print_success "TPM installed"
else
    print_warning "TPM already installed"
fi

# Install vim-plug for Neovim
print_status "Setting up vim-plug for Neovim..."
NVIM_AUTOLOAD_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload"
if [ ! -f "$NVIM_AUTOLOAD_DIR/plug.vim" ]; then
    print_status "Installing vim-plug..."
    curl -fLo "$NVIM_AUTOLOAD_DIR/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    print_success "vim-plug installed"
else
    print_warning "vim-plug already installed"
fi

# Auto-install zplug plugins
print_status "Installing zsh plugins with zplug..."
if [ -d ~/.zplug ] && [ -f ~/.zshrc ]; then
    print_status "Running zplug install in zsh..."
    # Run zplug install in a proper zsh environment with explicit path
    export ZPLUG_HOME="$HOME/.zplug"
    zsh -c "export ZPLUG_HOME='$HOME/.zplug' && source '$HOME/.zplug/init.zsh' && source '$HOME/.zshrc' && zplug install" 2>/dev/null || {
        print_warning "zplug install failed, plugins will be installed on first zsh startup"
        print_status "This is normal on NixOS - plugins will auto-install when you first start zsh"
    }
    print_success "zsh plugins setup completed"
else
    print_warning "zplug or .zshrc not found, plugins will be installed on first zsh startup"
fi

# Auto-install tmux plugins
print_status "Installing tmux plugins..."
if [ -d ~/.tmux/plugins/tpm ]; then
    # Start tmux in detached mode and install plugins
    tmux new-session -d -s setup_session 2>/dev/null || true
    tmux send-keys -t setup_session '~/.tmux/plugins/tpm/scripts/install_plugins.sh' Enter
    sleep 3
    tmux kill-session -t setup_session 2>/dev/null || true
    print_success "tmux plugins installed"
fi

# Auto-install neovim plugins
print_status "Installing neovim plugins..."
if [ -f "$NVIM_AUTOLOAD_DIR/plug.vim" ]; then
    # Install plugins in headless mode
    nvim --headless +PlugInstall +qall
    print_success "neovim plugins installed"
fi

print_success "🎉 Dotfiles setup complete with full automation!"
echo ""
print_status "Next steps:"
echo "1. Run 'sudo nixos-rebuild switch' to apply the NixOS configuration"
echo "2. Make sure zsh is your default shell: 'chsh -s \$(which zsh)'"
echo "3. Restart your terminal or run 'zsh' to start using zsh"
echo "4. Plugins will auto-install on first zsh startup if not already installed"
echo ""
print_status "Plugin managers installed:"
echo "  • zplug: Zsh plugin manager"
echo "  • TPM: Tmux plugin manager"
echo "  • vim-plug: Neovim plugin manager"
echo ""
print_status "Note: On NixOS, some plugins may install on first shell startup rather than during setup."
