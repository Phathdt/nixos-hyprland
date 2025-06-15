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
  ];

  system.stateVersion = "25.05";
}
