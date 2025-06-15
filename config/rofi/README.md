# Rofi Configuration

Beautiful Material Palenight themed application launcher for Hyprland.

## Features

- **Material Palenight Theme**: Dark purple theme with beautiful accent colors
- **Multiple Variants**: Solid and transparent versions
- **Modern UI**: Rounded corners, proper spacing, and smooth animations
- **Multiple Modes**: Applications, run commands, and window switcher
- **Fuzzy Search**: Smart matching for quick app launching
- **Icon Support**: Beautiful Papirus Dark icons
- **JetBrainsMono Font**: Consistent with terminal setup

## Themes

### 1. Material Palenight (Default)
- **File**: `material-palenight.rasi`
- **Style**: Solid backgrounds with Material Palenight colors
- **Best for**: General use, better readability

### 2. Material Palenight Transparent
- **File**: `material-palenight-transparent.rasi`
- **Style**: Semi-transparent backgrounds for modern look
- **Best for**: Desktop with wallpapers, modern aesthetic

### 3. Catppuccin Macchiato
- **File**: `catppuccin-macchiato.rasi`
- **Style**: Catppuccin color scheme
- **Best for**: Alternative color preference

## Color Palette

Material Palenight colors used:

```
Background Primary:   #292D3E
Background Secondary: #1E1E2E
Selected Background:  #3A3F58
Text Primary:         #EEFFFF
Text Secondary:       #A6ACCD
Accent:              #C792EA (Purple)
Accent Alt:          #82AAFF (Blue)
Accent Urgent:       #FF5370 (Red)
```

## Usage

### Basic Commands

```bash
# Show applications
rofi -show drun

# Show run dialog
rofi -show run

# Show window switcher
rofi -show window

# Show all modes
rofi -show combi
```

### Theme Switching

Use the included theme switcher script:

```bash
# Switch to Material Palenight (default)
~/.config/rofi/switch-theme.sh palenight

# Switch to transparent variant
~/.config/rofi/switch-theme.sh palenight-transparent

# Switch to Catppuccin
~/.config/rofi/switch-theme.sh catppuccin

# Show available themes
~/.config/rofi/switch-theme.sh
```

### Hyprland Integration

Add to your Hyprland config:

```conf
# Application launcher
bind = SUPER, D, exec, rofi -show drun

# Run dialog
bind = SUPER, R, exec, rofi -show run

# Window switcher
bind = ALT, TAB, exec, rofi -show window
```

## Configuration

### Main Config (`config.rasi`)

Key settings:
- **Modi**: `drun,run,window` - Available modes
- **Font**: JetBrainsMono Nerd Font 12
- **Terminal**: Alacritty
- **Icons**: Papirus Dark theme
- **Matching**: Fuzzy search enabled

### Customization

To customize themes, edit the `.rasi` files in `themes/` directory:

1. **Colors**: Modify the color variables at the top
2. **Sizing**: Adjust `width`, `padding`, `margin` values
3. **Fonts**: Change font family and sizes
4. **Transparency**: Modify alpha values in hex colors

## Keybindings

### In Rofi
- **Enter**: Launch selected application
- **Escape**: Close rofi
- **Tab**: Switch between modes
- **Ctrl+J/K**: Navigate up/down
- **Ctrl+U**: Clear input
- **Ctrl+A**: Select all text
- **Ctrl+E**: Go to end of line

### Mouse Support
- **Click**: Select item
- **Double-click**: Launch application
- **Scroll**: Navigate list

## Dependencies

Required packages (included in NixOS config):
- `rofi` - Main application
- `rofi-wayland` - Wayland support
- `papirus-icon-theme` - Icon theme
- `nerd-fonts.jetbrains-mono` - Font

## Troubleshooting

### Icons not showing
1. Ensure Papirus icon theme is installed
2. Check icon theme setting in config.rasi
3. Verify applications have desktop files

### Theme not applying
1. Check theme file path in config.rasi
2. Verify theme file exists in themes/ directory
3. Use theme switcher script for proper switching

### Font issues
1. Ensure JetBrainsMono Nerd Font is installed
2. Check font name in theme files
3. Verify font cache: `fc-cache -fv`

### Transparency not working
1. Ensure compositor supports transparency
2. Check if transparency is enabled in Hyprland
3. Try the solid theme variant instead
