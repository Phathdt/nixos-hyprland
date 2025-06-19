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
    lsof

    # Input method
    fcitx5
    fcitx5-unikey
    fcitx5-gtk
    libsForQt5.fcitx5-qt
    libsForQt5.fcitx5-with-addons
    kdePackages.fcitx5-qt
    kdePackages.fcitx5-with-addons

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

    # System monitoring and control
    cliphist
    networkmanagerapplet

    # Bluetooth
    blueman
    bluez
    bluez-tools

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

    # Database GUI tools
    dbeaver-bin

    # Office and productivity
    wpsoffice

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
