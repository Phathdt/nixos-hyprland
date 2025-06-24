#!/bin/bash

CURSOR_DIR="$HOME/.local/share/applications"
CURSOR_BIN="$HOME/.local/bin"
CURSOR_APPIMAGE="$HOME/Applications/cursor.AppImage"

echo "=== Cursor AppImage Persistent Setup ==="
echo ""

echo "1. Tạo directories:"
mkdir -p "$HOME/Applications"
mkdir -p "$CURSOR_BIN"
mkdir -p "$CURSOR_DIR"

echo "2. Download Cursor AppImage:"
if [ ! -f "$CURSOR_APPIMAGE" ]; then
    echo "   Downloading..."
    wget https://downloader.cursor.sh/linux/appimage/x64 -O "$CURSOR_APPIMAGE"
    chmod +x "$CURSOR_APPIMAGE"
    echo "   ✅ Downloaded"
else
    echo "   ✅ Already exists"
fi

echo "3. Create desktop entry:"
cat > "$CURSOR_DIR/cursor.desktop" << EOF
[Desktop Entry]
Name=Cursor
Comment=The AI-first code editor
Exec=$CURSOR_APPIMAGE
Icon=cursor
Type=Application
Categories=Development;TextEditor;
MimeType=text/plain;inode/directory;
EOF

echo "4. Create symlink for terminal access:"
ln -sf "$CURSOR_APPIMAGE" "$CURSOR_BIN/cursor"

echo "5. Extract icon (optional):"
if command -v convert &> /dev/null; then
    "$CURSOR_APPIMAGE" --appimage-extract-and-run --help &> /dev/null
    # Try to extract icon from AppImage
    echo "   Icon extraction available"
fi

echo "6. Update desktop database:"
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$CURSOR_DIR"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "🔄 Rebuild-safe locations:"
echo "   - AppImage: $CURSOR_APPIMAGE"
echo "   - Desktop: $CURSOR_DIR/cursor.desktop"
echo "   - Symlink: $CURSOR_BIN/cursor"
echo ""
echo "📝 Usage:"
echo "   - GUI: Search 'Cursor' in applications"
echo "   - Terminal: cursor filename.py"
echo "   - Direct: $CURSOR_APPIMAGE"
echo ""
echo "🔧 To update Cursor:"
echo "   rm $CURSOR_APPIMAGE"
echo "   Re-run this script"
