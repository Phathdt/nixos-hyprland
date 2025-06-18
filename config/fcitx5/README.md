# fcitx5 Vietnamese Input Method Setup

## What has been configured:

### 1. NixOS Configuration
- Added fcitx5 packages to `nixos/packages.nix`:
  - fcitx5
  - fcitx5-qt
  - fcitx5-gtk
  - fcitx5-unikey
  - fcitx5-configtool
  - fcitx5-chinese-addons

### 2. Input Method Configuration
- Enabled fcitx5 in `nixos/locale.nix`
- Set required environment variables:
  - GTK_IM_MODULE=fcitx
  - QT_IM_MODULE=fcitx
  - XMODIFIERS=@im=fcitx

### 3. Autostart Configuration
- Added fcitx5 daemon to Hyprland autostart in `config/hypr/modules/autostart.conf`

## How to use:

### 1. Rebuild your NixOS system:
```bash
sudo nixos-rebuild switch
```

### 2. Run the setup script:
```bash
./scripts/setup-fcitx5.sh
```

### 3. Configure input methods:
- The script will open fcitx5-configtool
- Click "Add input method"
- Search for "Unikey" or "Vietnamese"
- Add "Vietnamese (Unikey)"
- Configure hotkeys (default: Ctrl+Space to switch)

### 4. Test Vietnamese input:
- Open any text application
- Press Ctrl+Space to switch between English and Vietnamese
- Type Vietnamese text with Telex typing method

## Troubleshooting:

If fcitx5 doesn't work:
1. Check if the daemon is running: `ps aux | grep fcitx5`
2. Restart the daemon: `pkill fcitx5 && fcitx5 -d`
3. Verify environment variables: `env | grep -E "(GTK_IM|QT_IM|XMODIFIERS)"`
4. Log out and log back in to ensure all environment variables are loaded
