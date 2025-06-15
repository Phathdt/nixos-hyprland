# NixOS Hyprland Dotfiles

My personal dotfiles configuration for NixOS with Hyprland window manager.

## Features

- **NixOS Configuration**: Modular NixOS system configuration
- **Hyprland**: Wayland compositor with custom configuration
- **Waybar**: Material Palenight themed status bar with comprehensive system monitoring
- **Terminal Setup**: Alacritty + Tmux with custom themes
- **Development Environment**: Neovim with essential plugins, Git, and productivity tools
- **Automated Setup**: One-command installation script with full automation
- **Plugin Management**: Auto-installation of all plugins without manual intervention

## Structure

```
├── config/                    # XDG config files → ~/.config/
│   ├── alacritty/            # Terminal emulator config
│   ├── hypr/                 # Hyprland window manager
│   ├── nvim/                 # Neovim editor configuration
│   │   └── init.vim          # Main neovim config with plugins
│   ├── rofi/                 # Application launcher
│   ├── tmux/                 # Terminal multiplexer (XDG)
│   ├── waybar/               # Status bar with Material Palenight theme
│   │   ├── config.json       # Waybar modules and layout
│   │   └── style.css         # Material Palenight styling
│   └── wlogout/              # Power menu configuration
│       ├── layout            # Power menu layout
│       └── style.css         # Material Palenight styling
├── root_config/              # Home directory dotfiles → ~/
│   ├── git/                  # Git configuration
│   │   ├── .gitconfig        # → ~/.gitconfig
│   │   └── .gitignore_global # → ~/.gitignore_global
│   ├── tmux/                 # Tmux configuration
│   │   └── .tmux.conf        # → ~/.tmux.conf
│   └── zsh/                  # Zsh configuration
│       └── .zshrc            # → ~/.zshrc (with auto zplug setup)
├── nixos/                    # NixOS system configuration
│   ├── configuration.nix     # Main config (imports only)
│   ├── boot.nix             # Boot loader settings
│   ├── desktop.nix          # Hyprland + audio + services
│   ├── fonts.nix            # Font configuration
│   ├── locale.nix           # Timezone & locale
│   ├── networking.nix       # Network settings
│   ├── packages.nix         # System packages
│   ├── programs.nix         # Shell & program configs (minimal)
│   ├── ssh.nix              # SSH server configuration
│   └── users.nix            # User accounts (zsh as default shell)
└── init.sh                  # Fully automated installation script
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

2. **Run the automated setup script**:
   ```bash
   # Full setup (default)
   ./init.sh

   # Or with specific options
   ./init.sh --help                # Show all available options
   ./init.sh --dotfiles-only       # Only update dotfiles
   ./init.sh --nixos-only          # Only rebuild NixOS
   ./init.sh --skip-nixos          # Setup everything except NixOS rebuild
   ./init.sh --skip-plugins        # Setup without plugin installation
   ```

3. **Restart terminal and enjoy!**
   ```bash
   # Zsh is now your default shell with all plugins auto-installed
   # No manual steps required!
   ```

## What the Setup Script Does

The `init.sh` script provides **flexible automation** with multiple options:

### Available Options

```bash
./init.sh [OPTIONS]

Options:
  --skip-nixos      Skip NixOS configuration rebuild
  --skip-dotfiles   Skip dotfiles and symlinks setup
  --skip-plugins    Skip plugin managers installation
  --skip-waybar     Skip Waybar configuration
  --force-nixos     Force NixOS rebuild even if no changes
  --dotfiles-only   Only setup dotfiles (skip nixos, plugins)
  --nixos-only      Only rebuild NixOS (skip dotfiles, plugins, waybar)
  --help, -h        Show help message

Examples:
  ./init.sh                    # Full setup (default)
  ./init.sh --dotfiles-only    # Only update dotfiles
  ./init.sh --nixos-only       # Only rebuild NixOS
  ./init.sh --skip-nixos       # Setup everything except NixOS rebuild
  ./init.sh --skip-plugins     # Setup without plugin installation
```

### What Each Mode Does

### 1. System Configuration
- Moves `/etc/nixos/hardware-configuration.nix` to the repo
- Creates symlinks: `nixos/configuration.nix` → `/etc/nixos/configuration.nix`
- Links all config folders: `config/*` → `~/.config/*`
- Links all dotfiles: `root_config/*/.file` → `~/.file`

### 2. Plugin Managers Installation
- **zplug**: Zsh plugin manager with Oh My Zsh integration
- **TPM**: Tmux plugin manager
- **vim-plug**: Neovim plugin manager

### 3. Automatic Plugin Installation
- **Zsh plugins**: Auto-installs via zplug (no prompts)
  - Oh My Zsh framework + robbyrussell theme
  - Git, tmux, docker, docker-compose, kubectl plugins
  - zsh-autosuggestions, zsh-completions, zsh-syntax-highlighting
- **Tmux plugins**: Auto-installs via TPM
- **Neovim plugins**: Auto-installs via vim-plug
- **Zero manual intervention required!**

### 4. Shell Configuration
- NixOS automatically sets zsh as default shell
- No need to run `chsh` manually
- All plugins load automatically on first zsh startup

## Architecture

### NixOS Responsibilities
- Enable zsh program system-wide
- Set zsh as default shell for user
- Install system packages and services
- Configure desktop environment (Hyprland)

### Plugin Managers Responsibilities
- **zplug**: Manages Oh My Zsh framework, themes, and all zsh plugins
- **TPM**: Manages tmux plugins
- **vim-plug**: Manages neovim plugins

### Dotfiles Responsibilities
- All detailed configurations (aliases, functions, keybindings)
- Personal customizations and preferences
- Application-specific settings

## Key Components

### NixOS Configuration

- **Modular design**: Each component in separate files
- **Minimal programs.nix**: Only enables zsh, detailed config in dotfiles
- **Hyprland**: Wayland compositor with Xwayland support
- **Audio**: PipeWire with ALSA/Pulse compatibility
- **SSH**: Secure remote access with key authentication
- **Docker**: Container virtualization with auto-start
- **Fonts**: JetBrainsMono Nerd Font and Noto fonts

### Zsh Configuration (Managed by zplug)

- **Framework**: Oh My Zsh with robbyrussell theme
- **Plugins**: git, tmux, docker, docker-compose, kubectl
- **Enhancements**: autosuggestions, completions, syntax-highlighting
- **Auto-installation**: No manual prompts or confirmations
- **Custom aliases**: Development shortcuts and productivity helpers

### Applications

- **Terminal**: Alacritty with custom theme and JetBrainsMono Nerd Font
- **Shell**: Zsh with complete Oh My Zsh ecosystem
- **Editor**: Neovim with essential editing plugins
- **Browser**: Brave, Google Chrome
- **File Manager**: Nautilus
- **Launcher**: Rofi with Wayland support
- **Status Bar**: Waybar with Material Palenight theme
- **Power Menu**: Wlogout with Material Palenight theme

### Development Tools

- **Git**: Pre-configured with aliases and global gitignore
- **Docker**: Container platform with Docker Compose
- **Neovim**: Minimal setup for simple editing:
  - Git integration (Fugitive)
  - Text editing (Surround, Auto-pairs, Comments, Multiple-cursors)
  - Navigation (EasyMotion, Enhanced search)
  - Visual enhancements (Airline, IndentLine, Trailing-whitespace)
  - Theme (Palenight)
- **Tmux**: Custom keybindings (Ctrl+s prefix) with vim integration
- **Terminal**: 256-color support, clipboard integration
- **Fonts**: JetBrainsMono Nerd Font for icons and symbols

## Workflow

### Initial Setup
1. Run `./init.sh` - Sets up dotfiles + installs plugin managers
2. Run `sudo nixos-rebuild switch` - Applies NixOS config + sets zsh as default
3. Restart terminal - Zsh automatically becomes default shell
4. Plugins auto-install via zplug on first startup

### Daily Usage
- **Fast iteration**: Quick config changes without NixOS rebuilds
- **Familiar workflow**: Traditional plugin managers for flexibility
- **Clean separation**: NixOS for system, dotfiles for personal config
- **Portable**: Dotfiles work across different systems

## Customization

### Adding New Configurations

1. **For ~/.config/ files**: Add to `config/` directory
2. **For ~/ dotfiles**: Add to `root_config/` directory with dot prefix
3. **For system packages**: Edit `nixos/packages.nix`
4. **For zsh plugins**: Edit `root_config/zsh/.zshrc` and add zplug entries

### Zsh Plugins

Add new plugins to `root_config/zsh/.zshrc`:

```bash
# Add new zplug plugin
zplug "user/plugin-name"

# Add Oh My Zsh plugin
zplug "plugins/plugin-name", from:oh-my-zsh
```

Plugins will auto-install on next zsh startup.

### Tmux Plugins

Plugins are managed by [TPM](https://github.com/tmux-plugins/tpm):

- **Install**: `Ctrl+s + I`
- **Update**: `Ctrl+s + U`
- **Uninstall**: `Ctrl+s + Alt + u`

### Waybar Configuration

The Waybar is configured with Material Palenight theme and includes:

**Modules (Left to Right):**
- **Workspaces**: Hyprland workspace indicators with icons
- **Window Title**: Current active window title
- **Clock**: Time display (center)
- **System Tray**: Application tray icons
- **Idle Inhibitor**: Prevents screen from sleeping
- **Audio**: Volume control with PulseAudio
- **Network**: WiFi/Ethernet status
- **CPU**: Processor usage percentage
- **Memory**: RAM usage percentage
- **Temperature**: System temperature monitoring
- **Backlight**: Screen brightness control
- **Battery**: Battery status and percentage
- **Power**: Power menu button

**Interactive Features:**
- Click audio module to open `pavucontrol`
- Right-click network to open network settings
- Click power button to open logout menu
- Scroll on backlight to adjust brightness
- Hover for detailed tooltips

**Restart Waybar:**
```bash
pkill waybar && waybar &
```

### Git Configuration

Update your personal info in `root_config/git/.gitconfig`:

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
- `Ctrl+h/j/k/l`: Navigate panes (Vim-style with smart vim integration)

### Neovim (Leader: Space)

- `Space + /`: Toggle comment
- `Space + v`: Vertical split
- `Space + h`: Horizontal split
- `Space + s`: Jump to 2 characters (EasyMotion)
- `Space + w`: Jump to word (EasyMotion)
- `Ctrl+h/j/k/l`: Navigate windows (integrates with tmux)
- `/`, `?`: Search forward/backward
- `*`, `#`: Search word under cursor

### Hyprland

See `config/hypr/hyprland.conf` for complete keybindings.

## Benefits

### Compared to Home Manager
- **Faster iteration**: No rebuilds for dotfile changes
- **Familiar tools**: Traditional plugin managers
- **Flexibility**: Easy to modify and experiment
- **Portability**: Dotfiles work on non-NixOS systems

### Compared to Manual Setup
- **Full automation**: Zero manual steps
- **Reproducible**: Consistent setup across machines
- **Version controlled**: All configs in git
- **Modular**: Easy to enable/disable components

## Troubleshooting

### Common Issues

1. **Hardware config not found**: Run `sudo nixos-generate-config` first
2. **Broken symlinks**: Re-run `./init.sh` to fix
3. **Zsh not default**: Check if `nixos-rebuild switch` was run
4. **Plugins not loading**: Restart terminal or run `source ~/.zshrc`

### Debug Commands

```bash
# Check current shell
echo $SHELL

# Check symlinks
ls -la ~/.zshrc ~/.tmux.conf ~/.gitconfig

# Check zplug status
zplug status

# Reinstall plugins
zplug clear && zplug install

# Test Waybar configuration (on NixOS)
waybar --config ~/.config/waybar/config.json --style ~/.config/waybar/style.css
```

### Logs

- **NixOS build**: `sudo nixos-rebuild switch --show-trace`
- **Hyprland**: `journalctl -u display-manager`
- **Waybar**: `waybar --log-level debug`

### Notes

- **Testing on macOS**: Waybar cannot start without a Wayland/X11 display, but configuration files will be properly set up
- **GTK3 CSS**: Waybar uses GTK3 CSS which has some limitations compared to web CSS (no `transform`, `cubic-bezier`, etc.)
- **NixOS specific**: Some features like hardware monitoring require NixOS environment

## Contributing

Feel free to fork and customize for your own setup!

## License

MIT
