# GTK Material Palenight Theme

Material Palenight theme configuration for GTK applications, specifically optimized for Thunar file manager.

## Files

- `settings.ini` - GTK 3.0 theme settings (dark theme, Papirus icons, JetBrains Mono font)
- `gtk.css` - Custom CSS for Thunar with Material Palenight colors

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
- Custom Thunar styling (sidebar, header, toolbar, content area)
- Papirus Dark icon theme
- JetBrains Mono font
- Catppuccin cursor theme
- Smooth hover effects and transitions
- Enhanced button and entry field styling
- Custom context menu styling

## Thunar Specific Features

- **Sidebar**: Dark background with blue accent for selected items
- **Toolbar**: Transparent buttons with hover effects
- **Path bar**: Custom styled breadcrumb navigation
- **Icon view**: Rounded selection with smooth transitions
- **List view**: Consistent dark theme with hover states
- **Context menu**: Rounded corners with proper spacing
- **Dialog boxes**: Consistent theming across all dialogs

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
# Restart Thunar
pkill thunar && thunar &

# Or restart your session
```

## Thunar Configuration

For best results, configure Thunar preferences:
- **View → Side Pane**: Enable for better navigation
- **View → Status Bar**: Enable for file information
- **Edit → Preferences → Display**: Set icon size and view options
