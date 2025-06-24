#!/usr/bin/env bash

set -e  # Exit on error

TABLEPLUS_DIR="$HOME/.local/share/applications"
TABLEPLUS_BIN="$HOME/.local/bin"
TABLEPLUS_APPIMAGE="$HOME/Applications/tableplus.AppImage"

echo "=== TablePlus AppImage Setup for NixOS ==="
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
mkdir -p "$TABLEPLUS_BIN"
mkdir -p "$TABLEPLUS_DIR"
echo "   ✅ Directories created"

echo ""
echo "2. Copy TablePlus AppImage from Downloads:"
SOURCE_APPIMAGE="$HOME/Downloads/TablePlus.AppImage"

if [ ! -f "$SOURCE_APPIMAGE" ]; then
    echo "   ❌ Source AppImage not found: $SOURCE_APPIMAGE"
    echo "   💡 Please ensure you have downloaded TablePlus.AppImage to ~/Downloads/"
    exit 1
fi

# Check source file size
SOURCE_SIZE=$(stat -f%z "$SOURCE_APPIMAGE" 2>/dev/null || stat -c%s "$SOURCE_APPIMAGE" 2>/dev/null || echo 0)
if [ "$SOURCE_SIZE" -lt 1000000 ]; then
    echo "   ❌ Source file too small ($SOURCE_SIZE bytes), likely corrupted"
    exit 1
fi

echo "   📁 Found source: $SOURCE_APPIMAGE ($SOURCE_SIZE bytes)"

if [ ! -f "$TABLEPLUS_APPIMAGE" ]; then
    echo "   📋 Copying AppImage to target location..."
    cp "$SOURCE_APPIMAGE" "$TABLEPLUS_APPIMAGE"
    chmod +x "$TABLEPLUS_APPIMAGE"
    echo "   ✅ AppImage copied and made executable"
else
    # Check if existing file is good
    EXISTING_SIZE=$(stat -f%z "$TABLEPLUS_APPIMAGE" 2>/dev/null || stat -c%s "$TABLEPLUS_APPIMAGE" 2>/dev/null || echo 0)
    if [ "$EXISTING_SIZE" -gt 1000000 ]; then
        echo "   ✅ Already exists: $TABLEPLUS_APPIMAGE ($EXISTING_SIZE bytes)"
    else
        echo "   🔄 Replacing corrupted file ($EXISTING_SIZE bytes) with good copy..."
        cp "$SOURCE_APPIMAGE" "$TABLEPLUS_APPIMAGE"
        chmod +x "$TABLEPLUS_APPIMAGE"
        echo "   ✅ AppImage replaced and made executable"
    fi
fi

echo ""
echo "3. Creating desktop entry (NixOS compatible)..."
cat > "$TABLEPLUS_DIR/tableplus.desktop" << EOF
[Desktop Entry]
Name=TablePlus
Comment=Modern, native database client
Exec=appimage-run $TABLEPLUS_APPIMAGE %F
Icon=tableplus
Type=Application
Categories=Development;Database;Office;
MimeType=application/x-sqlite3;application/x-mysql;application/x-postgresql;
StartupNotify=true
StartupWMClass=tableplus
EOF
echo "   ✅ Desktop entry created with appimage-run"

echo ""
echo "4. Creating terminal wrapper script..."
cat > "$TABLEPLUS_BIN/tableplus" << 'EOF'
#!/usr/bin/env bash
# NixOS AppImage wrapper for TablePlus
exec appimage-run "$HOME/Applications/tableplus.AppImage" "$@"
EOF
chmod +x "$TABLEPLUS_BIN/tableplus"
echo "   ✅ Wrapper script created: $TABLEPLUS_BIN/tableplus"

echo ""
echo "5. Updating desktop database..."
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$TABLEPLUS_DIR" 2>/dev/null || true
    echo "   ✅ Desktop database updated"
else
    echo "   ⚠️  update-desktop-database not found, skipping"
fi

echo ""
echo "6. Testing NixOS AppImage setup..."
if [ -x "$TABLEPLUS_APPIMAGE" ]; then
    echo "   ✅ AppImage is executable"

    # Test appimage-run with the AppImage
    echo "   🧪 Testing with appimage-run..."
    if timeout 10 appimage-run "$TABLEPLUS_APPIMAGE" --version &>/dev/null; then
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
echo "   - Desktop entry uses 'appimage-run $TABLEPLUS_APPIMAGE'"
echo "   - Terminal command is wrapper script using appimage-run"
echo ""
echo "🔄 Rebuild-safe locations:"
echo "   - AppImage: $TABLEPLUS_APPIMAGE"
echo "   - Desktop: $TABLEPLUS_DIR/tableplus.desktop"
echo "   - Wrapper: $TABLEPLUS_BIN/tableplus"
echo ""
echo "📝 Usage:"
echo "   - GUI: Search 'TablePlus' in applications"
echo "   - Terminal: tableplus"
echo "   - Direct: appimage-run $TABLEPLUS_APPIMAGE"
echo ""
echo "🧪 Quick test:"
echo "   tableplus --version"
echo "   # OR"
echo "   appimage-run $TABLEPLUS_APPIMAGE --version"
echo ""
echo "🔧 To update TablePlus:"
echo "   1. Download new TablePlus.AppImage to ~/Downloads/"
echo "   2. rm $TABLEPLUS_APPIMAGE && ./scripts/tableplus-appimage-setup.sh"
