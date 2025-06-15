# NixOS Hyprland Dotfiles

My personal dotfiles configuration for NixOS with Hyprland window manager.

## Features

- **NixOS Configuration**: Modular NixOS system configuration
- **Hyprland**: Wayland compositor with custom configuration
- **Terminal Setup**: Alacritty + Tmux with custom themes
- **Development Environment**: Neovim with essential plugins, Git, and productivity tools
- **Automated Setup**: One-command installation script

## Structure

```
├── config/                    # XDG config files → ~/.config/
│   ├── alacritty/            # Terminal emulator config
│   ├── hypr/                 # Hyprland window manager
│   ├── nvim/                 # Neovim editor configuration
│   │   └── init.vim          # Main neovim config with plugins
│   ├── rofi/                 # Application launcher
│   └── tmux/                 # Terminal multiplexer (XDG)
├── root_config/              # Home directory dotfiles → ~/
│   ├── git/                  # Git configuration
│   │   ├── gitconfig         # → ~/.gitconfig
│   │   └── gitignore_global  # → ~/.gitignore_global
│   └── tmux/                 # Tmux configuration
│       └── tmux.conf         # → ~/.tmux.conf
├── nixos/                    # NixOS system configuration
│   ├── configuration.nix     # Main config (imports only)
│   ├── boot.nix             # Boot loader settings
│   ├── desktop.nix          # Hyprland + audio + services
│   ├── fonts.nix            # Font configuration
│   ├── locale.nix           # Timezone & locale
│   ├── networking.nix       # Network settings
│   ├── packages.nix         # System packages
│   ├── programs.nix         # Shell & program configs
│   ├── ssh.nix              # SSH server configuration
│   └── users.nix            # User accounts
└── init.sh                  # Installation script
```

## Installation

### Prerequisites

- NixOS system
- Git installed
- Internet connection

### Quick Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/nixos-hyprland.git
   cd nixos-hyprland
   ```

2. **Run the setup script**:
   ```bash
   ./init.sh
   ```

3. **Apply NixOS configuration**:
   ```bash
   sudo nixos-rebuild switch
   ```

4. **Install tmux plugins** (after reboot):
   ```bash
   tmux
   # Press Ctrl+s + I to install plugins
   ```

5. **Install neovim plugins**:
   ```bash
   # Install vim-plug
   curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

   # Open neovim and install plugins
   nvim
   # Run :PlugInstall
   ```

## What the Setup Script Does

The `init.sh` script automatically:

1. **Moves hardware configuration**: Copies `/etc/nixos/hardware-configuration.nix` to the repo
2. **Creates symlinks**:
   - `nixos/configuration.nix` → `/etc/nixos/configuration.nix`
   - `config/*` → `~/.config/*`
   - `root_config/*/files` → `~/.files`
3. **Installs TPM**: Clones tmux plugin manager
4. **Sets up Git**: Configures global Git settings

## Key Components

### NixOS Configuration

- **Modular design**: Each component in separate files
- **Hyprland**: Wayland compositor with Xwayland support
- **Audio**: PipeWire with ALSA/Pulse compatibility
- **SSH**: Secure remote access with key authentication
- **Docker**: Container virtualization with auto-start
- **Fonts**: JetBrainsMono Nerd Font and Noto fonts

### Applications

- **Terminal**: Alacritty with custom theme and JetBrainsMono Nerd Font
- **Shell**: Zsh with Oh My Zsh
- **Editor**: Neovim with essential editing plugins
- **Browser**: Brave, Google Chrome
- **File Manager**: Nautilus
- **Launcher**: Rofi with Wayland support

### Development Tools

- **Git**: Pre-configured with aliases and settings
- **Docker**: Container platform with Docker Compose
- **Neovim**: Minimal setup for simple editing:
  - Git integration (Fugitive)
  - Text editing (Surround, Auto-pairs, Comments, Multiple-cursors)
  - Navigation (EasyMotion, Enhanced search)
  - Visual enhancements (Airline, IndentLine, Trailing-whitespace)
  - Theme (Palenight)
- **Tmux**: Custom keybindings (Ctrl+s prefix)
- **Terminal**: 256-color support, clipboard integration
- **Fonts**: JetBrainsMono Nerd Font for icons and symbols

## Customization

### Adding New Configurations

1. **For ~/.config/ files**: Add to `config/` directory
2. **For ~/ dotfiles**: Add to `root_config/` directory
3. **For system packages**: Edit `nixos/packages.nix`

### Tmux Plugins

Plugins are managed by [TPM](https://github.com/tmux-plugins/tpm):

- **Install**: `Ctrl+s + I`
- **Update**: `Ctrl+s + U`
- **Uninstall**: `Ctrl+s + Alt + u`

### Git Configuration

Update your personal info in `root_config/git/gitconfig`:

```ini
[user]
    name = Your Name
    email = your.email@example.com
```

## Key Bindings

### Tmux (Prefix: Ctrl+s)

- `Ctrl+s + |`: Split horizontally
- `Ctrl+s + -`: Split vertically
- `Ctrl+s + h`: Open htop
- `Ctrl+s + r`: Reload config
- `Ctrl+h/j/k/l`: Navigate panes (Vim-style)

### Neovim (Leader: Space)

- `Space + /`: Toggle comment
- `Space + v`: Vertical split
- `Space + h`: Horizontal split
- `Space + s`: Jump to 2 characters (EasyMotion)
- `Space + w`: Jump to word (EasyMotion)
- `Ctrl+h/j/k/l`: Navigate windows
- `/`, `?`: Search forward/backward
- `*`, `#`: Search word under cursor

### Hyprland

See `config/hypr/hyprland.conf` for complete keybindings.

## Troubleshooting

### Common Issues

1. **Hardware config not found**: Run `sudo nixos-generate-config` first
2. **Tmux plugins not working**: Install TPM with `Ctrl+s + I`
3. **Git config not applied**: Check symlinks with `ls -la ~/.gitconfig`
4. **Neovim plugins not working**: Install vim-plug and run `:PlugInstall`

### Logs

- **NixOS build**: `sudo nixos-rebuild switch --show-trace`
- **Hyprland**: `journalctl -u display-manager`

## Contributing

Feel free to fork and customize for your own setup!

## License

MIT License - see LICENSE file for details.

---

**Note**: This configuration is tailored for my personal workflow. You may need to adjust settings, especially in `nixos/users.nix` and `root_config/git/gitconfig`.
