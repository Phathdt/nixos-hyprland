#!/usr/bin/env bash

set -e  # Exit on error

CURSOR_DIR="$HOME/.local/share/applications"
CURSOR_BIN="$HOME/.local/bin"
CURSOR_APPIMAGE="$HOME/Applications/cursor.AppImage"

echo "=== Cursor AppImage Setup for NixOS ==="
echo ""

# Check dependencies
echo "🔍 Checking NixOS AppImage support..."
if ! command -v appimage-run &> /dev/null; then
    echo "❌ appimage-run not found!"
    echo "   Please rebuild NixOS first: sudo nixos-rebuild switch"
    echo "   (appimage-run has been added to packages.nix)"
    exit 1
fi
echo "   ✅ appimage-run available"

if ! command -v wget &> /dev/null; then
    echo "❌ wget not found. Please install wget first."
    exit 1
fi

echo ""
echo "1. Creating directories..."
mkdir -p "$HOME/Applications"
mkdir -p "$CURSOR_BIN"
mkdir -p "$CURSOR_DIR"
echo "   ✅ Directories created"

echo ""
echo "2. Download Cursor AppImage:"
if [ ! -f "$CURSOR_APPIMAGE" ]; then
    echo "   🔄 Downloading latest Cursor AppImage..."

    # Use the generic download URL that redirects to latest
    DOWNLOAD_URL="https://downloads.cursor.com/production/979ba33804ac150108481c14e0b5cb970bda3266/linux/x64/Cursor-1.1.3-x86_64.AppImage"

    echo "   📡 Downloading from: $DOWNLOAD_URL"
    if wget --progress=bar:force "$DOWNLOAD_URL" -O "$CURSOR_APPIMAGE"; then
        chmod +x "$CURSOR_APPIMAGE"
        echo "   ✅ Downloaded and made executable"
    else
        echo "   ❌ Download failed!"
        echo "   💡 Try manual download:"
        echo "      wget https://downloads.cursor.com/production/979ba33804ac150108481c14e0b5cb970bda3266/linux/x64/Cursor-1.1.3-x86_64.AppImage -O $CURSOR_APPIMAGE"
        exit 1
    fi
else
    echo "   ✅ Already exists: $CURSOR_APPIMAGE"
fi

echo ""
echo "3. Creating desktop entry (NixOS compatible)..."
cat > "$CURSOR_DIR/cursor.desktop" << EOF
[Desktop Entry]
Name=Cursor
Comment=The AI-first code editor
Exec=appimage-run $CURSOR_APPIMAGE %F
Icon=cursor
Type=Application
Categories=Development;TextEditor;IDE;
MimeType=text/plain;inode/directory;
StartupNotify=true
StartupWMClass=cursor
EOF
echo "   ✅ Desktop entry created with appimage-run"

echo ""
echo "4. Creating terminal wrapper script..."
cat > "$CURSOR_BIN/cursor" << 'EOF'
#!/bin/bash
# NixOS AppImage wrapper for Cursor
exec appimage-run "$HOME/Applications/cursor.AppImage" "$@"
EOF
chmod +x "$CURSOR_BIN/cursor"
echo "   ✅ Wrapper script created: $CURSOR_BIN/cursor"

echo ""
echo "5. Updating desktop database..."
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$CURSOR_DIR" 2>/dev/null || true
    echo "   ✅ Desktop database updated"
else
    echo "   ⚠️  update-desktop-database not found, skipping"
fi

echo ""
echo "6. Testing NixOS AppImage setup..."
if [ -x "$CURSOR_APPIMAGE" ]; then
    echo "   ✅ AppImage is executable"

    # Test appimage-run with the AppImage
    echo "   🧪 Testing with appimage-run..."
    if timeout 10 appimage-run "$CURSOR_APPIMAGE" --version &>/dev/null; then
        echo "   ✅ AppImage runs successfully with appimage-run"
    else
        echo "   ⚠️  AppImage test timeout/failed, but continuing..."
    fi
else
    echo "   ❌ AppImage is not executable!"
    exit 1
fi

echo ""
echo "✅ NixOS AppImage setup complete!"
echo ""
echo "📋 Key points for NixOS:"
echo "   - AppImage runs via 'appimage-run' (not direct execution)"
echo "   - Desktop entry uses 'appimage-run $CURSOR_APPIMAGE'"
echo "   - Terminal command is wrapper script using appimage-run"
echo ""
echo "🔄 Rebuild-safe locations:"
echo "   - AppImage: $CURSOR_APPIMAGE"
echo "   - Desktop: $CURSOR_DIR/cursor.desktop"
echo "   - Wrapper: $CURSOR_BIN/cursor"
echo ""
echo "📝 Usage:"
echo "   - GUI: Search 'Cursor' in applications"
echo "   - Terminal: cursor filename.py"
echo "   - Direct: appimage-run $CURSOR_APPIMAGE"
echo ""
echo "🧪 Quick test:"
echo "   cursor --version"
echo "   # OR"
echo "   appimage-run $CURSOR_APPIMAGE --version"
echo ""
echo "🔧 To update Cursor:"
echo "   rm $CURSOR_APPIMAGE && ./scripts/cursor-appimage-setup.sh"
