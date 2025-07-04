{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "beekeeper-studio-5.1.5"
  ];

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
    lsof

    # Package management tools
    dpkg
    binutils

    # Shell and terminal
    oh-my-zsh
    tmux
    zsh
    fzf
    zoxide

    # Text editors
    neovim
    vim

    # Version control
    git
    git-cola
    gitFull

    # Wayland/Hyprland ecosystem
    grim
    hyprlock
    hyprpaper
    hyprpicker
    slurp
    swaybg
    swww
    wl-clipboard
    wtype

    # Window manager and desktop
    dunst
    rofi
    rofi-wayland
    rofimoji
    waybar
    wlogout
    eww
    swaynotificationcenter

    # Terminal emulators
    alacritty

    # File managers
    xfce.thunar
    xfce.xfconf

    # Web browsers
    brave
    google-chrome
    firefox

    # Media and audio
    pavucontrol
    playerctl
    # PipeWire audio tools
    wireplumber
    pipewire
    pulseaudio

    # System monitoring and control
    cliphist
    networkmanagerapplet

    # Bluetooth
    blueman
    bluez
    bluez-tools
    bluez-alsa

    # Communication
    telegram-desktop
    thunderbird

    # VPN
    openvpn
    networkmanager-openvpn
    networkmanagerapplet
    tailscale

    # Development tools
    docker
    docker-compose

    # API development and testing
    postman

    # System monitoring and performance
    btop
    htop
    iotop
    nethogs
    bandwhich
    lazydocker
    lazygit
    ctop
    dive
    neofetch

    # File and text processing
    ripgrep
    fd
    bat
    eza
    tree
    jq
    unzip
    zip
    p7zip

    # Network tools
    nmap
    rsync
    bind
    dnsutils

    # Programming languages and runtimes
    nodejs_22
    nodePackages.npm
    nodePackages.yarn
    go_1_24

    # Database and ORM tools
    postgresql
    redis
    redisinsight
    prisma-engines
    openssl
    pkg-config

    # Database management
    beekeeper-studio

    # Office and productivity
    wpsoffice

    # Image processing
    imagemagick

    # Image viewers
    imv

    # GTK themes and customization
    gtk-engine-murrine
    sassc

    # Icon themes
    colloid-icon-theme
    numix-icon-theme
    numix-icon-theme-circle
    papirus-icon-theme
    tela-icon-theme

    # Session management
    systemd
    dbus

    # AppImage support
    appimage-run
  ];
}
