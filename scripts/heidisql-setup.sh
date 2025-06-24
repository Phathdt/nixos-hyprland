#!/usr/bin/env bash

set -e  # Exit on error

PACKAGE_NAME="heidisql"
APP_NAME="HeidiSQL"
APP_COMMENT="Lightweight client for MySQL, MSSQL and PostgreSQL"
APP_CATEGORIES="Development;Database;Office;"
APP_ICON="heidisql"

APP_DIR="$HOME/.local/share/applications"
APP_BIN="$HOME/.local/bin"
INSTALL_DIR="$HOME/.local/opt/$PACKAGE_NAME"
DEB_EXTRACT_DIR="/tmp/${PACKAGE_NAME}_extract"

echo "=== HeidiSQL .deb Package Setup for NixOS ==="
echo ""

echo "🔍 Checking NixOS dependencies..."
if ! command -v dpkg &> /dev/null; then
    echo "❌ dpkg not found!"
    echo "   Please add dpkg to your NixOS packages.nix"
    exit 1
fi
echo "   ✅ dpkg available"

if ! command -v ar &> /dev/null; then
    echo "❌ ar not found!"
    echo "   Please add binutils to your NixOS packages.nix"
    exit 1
fi
echo "   ✅ ar available"

echo ""
echo "1. Creating directories..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$APP_BIN"
mkdir -p "$APP_DIR"
mkdir -p "$DEB_EXTRACT_DIR"
echo "   ✅ Directories created"

echo ""
echo "2. Locate HeidiSQL .deb file in Downloads:"
DEB_FILE=""
for file in "$HOME/Downloads"/*heidisql*.deb "$HOME/Downloads"/*HeidiSQL*.deb; do
    if [ -f "$file" ]; then
        DEB_FILE="$file"
        break
    fi
done

if [ -z "$DEB_FILE" ]; then
    echo "   ❌ No HeidiSQL .deb file found in ~/Downloads/"
    echo "   💡 Please place HeidiSQL .deb file in ~/Downloads/"
    echo "   💡 Expected pattern: *heidisql*.deb or *HeidiSQL*.deb"
    exit 1
fi

echo "   📁 Found: $DEB_FILE"

DEB_SIZE=$(stat -f%z "$DEB_FILE" 2>/dev/null || stat -c%s "$DEB_FILE" 2>/dev/null || echo 0)
echo "   📊 Size: $DEB_SIZE bytes"

echo ""
echo "3. Extracting HeidiSQL package..."
cd "$DEB_EXTRACT_DIR"

ar x "$DEB_FILE"
if [ -f "data.tar.xz" ]; then
    tar -xf data.tar.xz
elif [ -f "data.tar.gz" ]; then
    tar -xf data.tar.gz
elif [ -f "data.tar.bz2" ]; then
    tar -xf data.tar.bz2
else
    echo "   ❌ Unknown data archive format in .deb file"
    exit 1
fi
echo "   ✅ Package extracted"

echo ""
echo "4. Installing HeidiSQL to user directory..."
if [ -d "usr" ]; then
    cp -r usr/* "$INSTALL_DIR/" 2>/dev/null || true
fi
if [ -d "opt" ]; then
    cp -r opt/* "$INSTALL_DIR/" 2>/dev/null || true
fi

MAIN_EXECUTABLE=""
for possible_path in \
    "$INSTALL_DIR/bin/heidisql" \
    "$INSTALL_DIR/bin/HeidiSQL" \
    "$INSTALL_DIR/usr/bin/heidisql" \
    "$INSTALL_DIR/usr/bin/HeidiSQL" \
    "$INSTALL_DIR/share/heidisql/heidisql" \
    "$INSTALL_DIR/lib/heidisql/heidisql"; do
    if [ -f "$possible_path" ] && [ -x "$possible_path" ]; then
        MAIN_EXECUTABLE="$possible_path"
        break
    fi
done

if [ -z "$MAIN_EXECUTABLE" ]; then
    echo "   🔍 Searching for HeidiSQL executable in all directories..."
    MAIN_EXECUTABLE=$(find "$INSTALL_DIR" -name "*heidisql*" -type f -executable 2>/dev/null | head -1)
fi

if [ -z "$MAIN_EXECUTABLE" ]; then
    echo "   ❌ Could not find HeidiSQL executable"
    echo "   💡 Available files:"
    find "$INSTALL_DIR" -type f -executable 2>/dev/null | head -10
    exit 1
fi

echo "   ✅ Installed to: $INSTALL_DIR"
echo "   🎯 HeidiSQL executable: $MAIN_EXECUTABLE"

echo ""
echo "5. Creating NixOS-compatible wrapper for HeidiSQL..."
cat > "$APP_BIN/$PACKAGE_NAME" << EOF
#!/usr/bin/env bash

# NixOS wrapper for HeidiSQL
export LD_LIBRARY_PATH="$INSTALL_DIR/lib:$INSTALL_DIR/lib64:$INSTALL_DIR/usr/lib:$INSTALL_DIR/usr/lib64:\$LD_LIBRARY_PATH"
export PATH="$INSTALL_DIR/bin:$INSTALL_DIR/usr/bin:$INSTALL_DIR/sbin:$INSTALL_DIR/usr/sbin:\$PATH"

# Add NixOS system library paths
for lib_path in /run/current-system/sw/lib /run/current-system/sw/lib64 /usr/lib /usr/lib64; do
    if [ -d "\$lib_path" ]; then
        export LD_LIBRARY_PATH="\$lib_path:\$LD_LIBRARY_PATH"
    fi
done

# HeidiSQL might need these environment variables
export XDG_DATA_DIRS="$INSTALL_DIR/share:\$XDG_DATA_DIRS"
export XDG_CONFIG_DIRS="$INSTALL_DIR/etc/xdg:\$XDG_CONFIG_DIRS"

# Execute HeidiSQL
exec "$MAIN_EXECUTABLE" "\$@"
EOF

chmod +x "$APP_BIN/$PACKAGE_NAME"
echo "   ✅ Wrapper script created: $APP_BIN/$PACKAGE_NAME"

echo ""
echo "6. Creating desktop entry for HeidiSQL..."
cat > "$APP_DIR/${PACKAGE_NAME}.desktop" << EOF
[Desktop Entry]
Name=$APP_NAME
Comment=$APP_COMMENT
Exec=$APP_BIN/$PACKAGE_NAME %F
Icon=$APP_ICON
Type=Application
Categories=$APP_CATEGORIES
MimeType=application/x-mysql;application/x-postgresql;application/x-sqlite3;
StartupNotify=true
StartupWMClass=heidisql
Keywords=database;mysql;postgresql;sql;mariadb;
EOF
echo "   ✅ Desktop entry created"

echo ""
echo "7. Updating desktop database..."
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$APP_DIR" 2>/dev/null || true
    echo "   ✅ Desktop database updated"
else
    echo "   ⚠️  update-desktop-database not found, skipping"
fi

echo ""
echo "8. Testing HeidiSQL installation..."
if [ -x "$MAIN_EXECUTABLE" ]; then
    echo "   ✅ HeidiSQL executable is accessible"

    echo "   🧪 Testing wrapper script..."
    if timeout 5 "$APP_BIN/$PACKAGE_NAME" --version &>/dev/null || timeout 5 "$APP_BIN/$PACKAGE_NAME" --help &>/dev/null; then
        echo "   ✅ Wrapper script works"
    else
        echo "   ⚠️  Version/help test failed, but HeidiSQL should still work"
    fi
else
    echo "   ❌ HeidiSQL executable is not accessible!"
fi

echo ""
echo "9. Cleaning up..."
rm -rf "$DEB_EXTRACT_DIR"
echo "   ✅ Temporary files cleaned"

echo ""
echo "✅ HeidiSQL NixOS setup complete!"
echo ""
echo "📋 Installation details:"
echo "   - Package: $DEB_FILE"
echo "   - Installed to: $INSTALL_DIR"
echo "   - Executable: $MAIN_EXECUTABLE"
echo "   - Wrapper: $APP_BIN/$PACKAGE_NAME"
echo "   - Desktop: $APP_DIR/${PACKAGE_NAME}.desktop"
echo ""
echo "📝 Usage:"
echo "   - GUI: Search 'HeidiSQL' in applications"
echo "   - Terminal: heidisql"
echo "   - Direct: $MAIN_EXECUTABLE"
echo ""
echo "🔧 Database connections:"
echo "   - Supports MySQL, MariaDB, PostgreSQL, SQLite"
echo "   - Use GUI to configure database connections"
echo ""
echo "🧪 Quick test:"
echo "   heidisql --version"
echo "   # OR just run: heidisql"
echo ""
echo "💡 Troubleshooting:"
echo "   - If GUI doesn't start, try: DISPLAY=:0 heidisql"
echo "   - For missing libraries, check NixOS packages.nix"
echo "   - Wine might be needed for Windows version of HeidiSQL"
