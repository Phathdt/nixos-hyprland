#!/usr/bin/env bash

echo "🔧 Making all scripts executable..."
echo ""

# Function to make file executable and log it
make_executable() {
    local file="$1"

    if [ -f "$file" ]; then
        echo "  📁 Processing: $file"
        chmod +x "$file"
        if [ $? -eq 0 ]; then
            echo "    ✅ Made executable: $file"
        else
            echo "    ❌ Failed to make executable: $file"
        fi
        echo ""
    else
        echo "    ⚠️  File not found: $file"
        echo ""
    fi
}

# Make main scripts executable
echo "=== Main Scripts ==="
make_executable "init.sh"

# Make config/scripts executable
echo "=== Config Scripts ==="
if [ -d "config/scripts" ]; then
    for script in config/scripts/*.sh; do
        if [ -f "$script" ]; then
            make_executable "$script"
        fi
    done
else
    echo "  ⚠️  Directory not found: config/scripts"
    echo ""
fi

# Make sync scripts executable
echo "=== Sync Scripts ==="
if [ -d "scripts" ]; then
    for script in scripts/*.sh; do
        if [ -f "$script" ] && [ "$script" != "scripts/make-executable.sh" ]; then
            make_executable "$script"
        fi
    done
fi

# Final summary
echo "🎯 Summary:"
echo "  📊 Checking final permissions..."
echo ""

# Show final permissions
if [ -f "init.sh" ]; then
    echo "  📋 Main Scripts:"
    ls -la init.sh | while read line; do echo "    $line"; done
    echo ""
fi

if [ -d "config/scripts" ]; then
    echo "  📋 Config Scripts:"
    ls -la config/scripts/*.sh 2>/dev/null | while read line; do echo "    $line"; done
    echo ""
fi

if [ -d "scripts" ]; then
    echo "  📋 Utility Scripts:"
    ls -la scripts/*.sh 2>/dev/null | while read line; do echo "    $line"; done
    echo ""
fi

echo "✅ All scripts processing completed!"
