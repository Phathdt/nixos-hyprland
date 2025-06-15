{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget
    neovim
    wl-clipboard
    vim
    htop
    brave
    google-chrome
    alacritty
    kitty
    nautilus
    rofi
    rofi-wayland
    rofimoji
    cliphist
    wl-clipboard
    hyprlock
    playerctl
    hyprpicker
    dunst
    waybar
    swaybg
    grim
    slurp
    pavucontrol
    networkmanagerapplet
    brightnessctl
    jq
    zsh
    oh-my-zsh
    swww
    git
    vscode
    tmux
  ];
}
