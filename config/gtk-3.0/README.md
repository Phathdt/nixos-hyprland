# GTK Material Palenight Theme

Material Palenight theme configuration for GTK applications, specifically optimized for Nautilus file manager.

## Files

- `settings.ini` - GTK 3.0 theme settings (dark theme, Papirus icons, JetBrains Mono font)
- `gtk.css` - Custom CSS for Nautilus with Material Palenight colors

## Colors Used

- **Background Primary**: `#292d3e`
- **Background Secondary**: `#1e1e2e`
- **Background Selected**: `#3a3f58`
- **Text Primary**: `#a6accd`
- **Text Secondary**: `#676e95`
- **Accent**: `#82aaff` (Blue)
- **Accent Alt**: `#c792ea` (Purple)

## Features

- Dark theme with Material Palenight colors
- Custom Nautilus styling (sidebar, header, content area)
- Papirus Dark icon theme
- JetBrains Mono font
- Catppuccin cursor theme
- Smooth hover effects and transitions

## Usage

These files are automatically symlinked to `~/.config/gtk-3.0/` by the `init.sh` script.

To apply manually:
```bash
# Run the main setup script
./init.sh

# Or just the dotfiles part
./init.sh --dotfiles-only
```

## Restart Applications

After applying the theme, restart GTK applications to see changes:
```bash
# Restart Nautilus
pkill nautilus && nautilus &

# Or restart your session
```
