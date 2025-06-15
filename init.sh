#!/usr/bin/env bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default options
SKIP_NIXOS=false
SKIP_DOTFILES=false
SKIP_PLUGINS=false
SKIP_WAYBAR=false
FORCE_NIXOS=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-nixos)
            SKIP_NIXOS=true
            shift
            ;;
        --skip-dotfiles)
            SKIP_DOTFILES=true
            shift
            ;;
        --skip-plugins)
            SKIP_PLUGINS=true
            shift
            ;;
        --skip-waybar)
            SKIP_WAYBAR=true
            shift
            ;;
        --force-nixos)
            FORCE_NIXOS=true
            shift
            ;;
        --dotfiles-only)
            SKIP_NIXOS=true
            SKIP_PLUGINS=true
            shift
            ;;
        --nixos-only)
            SKIP_DOTFILES=true
            SKIP_PLUGINS=true
            SKIP_WAYBAR=true
            shift
            ;;
        --help|-h)
            echo "🚀 NixOS Hyprland Setup Script"
            echo ""
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --skip-nixos      Skip NixOS configuration rebuild"
            echo "  --skip-dotfiles   Skip dotfiles and symlinks setup"
            echo "  --skip-plugins    Skip plugin managers installation"
            echo "  --skip-waybar     Skip Waybar configuration"
            echo "  --force-nixos     Force NixOS rebuild even if no changes"
            echo "  --dotfiles-only   Only setup dotfiles (skip nixos, plugins)"
            echo "  --nixos-only      Only rebuild NixOS (skip dotfiles, plugins, waybar)"
            echo "  --help, -h        Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                    # Full setup (default)"
            echo "  $0 --dotfiles-only    # Only update dotfiles"
            echo "  $0 --nixos-only       # Only rebuild NixOS"
            echo "  $0 --skip-nixos       # Setup everything except NixOS rebuild"
            echo "  $0 --skip-plugins     # Setup without plugin installation"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

echo "🚀 Setting up NixOS dotfiles..."
echo "📋 Configuration:"
echo "   Skip NixOS: $SKIP_NIXOS"
echo "   Skip Dotfiles: $SKIP_DOTFILES"
echo "   Skip Plugins: $SKIP_PLUGINS"
echo "   Skip Waybar: $SKIP_WAYBAR"
echo ""

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

# Setup dotfiles and symlinks
if [ "$SKIP_DOTFILES" = false ]; then
    print_status "Setting up dotfiles and symlinks..."

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
            target_path="$HOME/.config/$config_name"

            print_status "Symlinking $config_name to ~/.config/..."

            # Remove existing directory/symlink if it exists
            if [ -L "$target_path" ]; then
                print_status "  Removing existing symlink: $target_path"
                rm "$target_path"
            elif [ -d "$target_path" ]; then
                print_status "  Removing existing directory: $target_path"
                rm -rf "$target_path"
            elif [ -f "$target_path" ]; then
                print_status "  Removing existing file: $target_path"
                rm "$target_path"
            fi

            # Create the symlink
            ln -sf "$config_dir" "$target_path"
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

                            # Process all files including hidden files (dotfiles)
                shopt -s nullglob dotglob
                for file in "$root_config_folder"/*; do
                    if [ -f "$file" ]; then
                        filename=$(basename "$file")
                        # Skip . and .. directories
                        [[ "$filename" == "." || "$filename" == ".." ]] && continue

                        # Remove existing symlink/file first
                        [ -L ~/"$filename" ] && rm ~/"$filename"
                        [ -f ~/"$filename" ] && rm ~/"$filename"

                        print_status "  Symlinking $filename to ~/$filename"
                        ln -sf "$file" ~/"$filename"
                    fi
                done
                shopt -u nullglob dotglob
            fi
        done
    fi
    print_success "Root config files linked"
else
    print_warning "Skipping dotfiles setup"
fi

# Setup plugin managers
if [ "$SKIP_PLUGINS" = false ]; then
    print_status "Setting up plugin managers..."

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
else
    print_warning "Skipping plugin managers setup"
fi

# Apply NixOS configuration
if [ "$SKIP_NIXOS" = false ]; then
    print_status "Applying NixOS configuration..."
    if [ "$FORCE_NIXOS" = true ]; then
        print_status "Force rebuilding NixOS configuration..."
        if sudo nixos-rebuild switch --upgrade; then
            print_success "NixOS configuration applied successfully!"
        else
            print_error "Failed to apply NixOS configuration. Please run 'sudo nixos-rebuild switch' manually."
        fi
    else
        if sudo nixos-rebuild switch; then
            print_success "NixOS configuration applied successfully!"
        else
            print_error "Failed to apply NixOS configuration. Please run 'sudo nixos-rebuild switch' manually."
        fi
    fi
else
    print_warning "Skipping NixOS configuration rebuild"
fi

# Apply Waybar configuration
if [ "$SKIP_WAYBAR" = false ]; then
    print_status "Setting up Waybar with Material Palenight theme..."
    if command -v waybar >/dev/null 2>&1; then
        # Check if we have a display (for testing on non-Linux systems)
        if [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
            # Kill existing waybar if running
            pkill waybar 2>/dev/null || true
            sleep 1

            # Start waybar with explicit config files
            waybar -c ~/.config/waybar/config.json -s ~/.config/waybar/style.css &
            sleep 2

            if pgrep -x "waybar" > /dev/null; then
                print_success "Waybar started with Material Palenight theme!"
            else
                print_warning "Waybar may need manual restart after reboot"
            fi
        else
            print_warning "No display available - Waybar will start automatically on NixOS with Hyprland"
            print_success "Waybar configuration ready for Material Palenight theme!"
        fi
    else
        print_warning "Waybar not found, will be available after NixOS rebuild"
    fi
else
    print_warning "Skipping Waybar setup"
fi

print_success "🎉 Setup completed!"
echo ""
print_success "✅ What's been configured:"
if [ "$SKIP_DOTFILES" = false ]; then
    echo "  • Dotfiles and configs symlinked"
fi
if [ "$SKIP_NIXOS" = false ]; then
    echo "  • NixOS system configuration applied"
    echo "  • Hyprland with modular configuration"
fi
if [ "$SKIP_PLUGINS" = false ]; then
    echo "  • Plugin managers installed and configured"
fi
if [ "$SKIP_WAYBAR" = false ]; then
    echo "  • Waybar with Material Palenight theme"
    echo "  • Wlogout power menu"
fi
echo ""
print_status "🚀 Ready to use:"
if [ "$SKIP_NIXOS" = false ]; then
    echo "  • Restart your session or reboot to see full setup"
    echo "  • Zsh is now your default shell with all plugins"
fi
if [ "$SKIP_WAYBAR" = false ]; then
    echo "  • Waybar will auto-start with Hyprland"
    echo "  • Click power button (󰐥) in Waybar for logout menu"
fi
echo ""
print_status "📝 Configuration files:"
echo "  • Waybar: ~/.config/waybar/"
echo "  • Hyprland: ~/.config/hypr/"
echo "  • All configs: ~/.config/"
echo ""
print_status "🔧 Useful commands:"
echo "  • Restart Waybar: pkill waybar && waybar -c ~/.config/waybar/config.json -s ~/.config/waybar/style.css &"
echo "  • Rebuild NixOS: sudo nixos-rebuild switch"
echo "  • Update dotfiles only: $0 --dotfiles-only"
echo "  • Rebuild NixOS only: $0 --nixos-only"
echo "  • Show help: $0 --help"
