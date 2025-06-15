{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./networking.nix
    ./locale.nix
    ./users.nix
    ./desktop.nix
    ./packages.nix
    ./programs.nix
    ./fonts.nix
    ./ssh.nix
    ./theme.nix
    ./gtk.nix
    ./services.nix
  ];

  system.stateVersion = "25.05";
}
