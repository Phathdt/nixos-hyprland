{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # System utilities
    acpi
    brightnessctl
    curl
    htop
    jq
    libnotify
    lm_sensors
    upower
    wget

    # Shell and terminal
    oh-my-zsh
    tmux
    zsh

    # Text editors
    neovim
    vim
    vscode
    code-cursor

    # Version control
    git

    # Wayland/Hyprland ecosystem
    grim
    hyprlock
    hyprpaper
    hyprpicker
    slurp
    swaybg
    swww
    wl-clipboard

    # Window manager and desktop
    dunst
    rofi
    rofi-wayland
    rofimoji
    waybar
    wlogout

    # Terminal emulators
    alacritty
    kitty

    # File managers
    xfce.thunar
    xfce.xfconf

    # Web browsers
    brave
    google-chrome

    # Media and audio
    pavucontrol
    playerctl

    # System monitoring and control
    cliphist
    networkmanagerapplet

    # Bluetooth
    blueman
    bluez
    bluez-tools

    # Communication
    telegram-desktop

    # Development tools
    docker
    docker-compose

    # Image processing
    imagemagick

    # GTK themes and customization
    gtk-engine-murrine
    sassc

    # Icon themes
    colloid-icon-theme
    numix-icon-theme
    numix-icon-theme-circle
    papirus-icon-theme
    tela-icon-theme
  ];
}
