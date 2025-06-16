{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./networking.nix
    ./locale.nix
    ./input-method.nix
    ./users.nix
    ./desktop.nix
    ./packages.nix
    ./unstable.nix
    ./programs.nix
    ./fonts.nix
    ./ssh.nix
    ./theme.nix
    ./gtk.nix
    ./services.nix
    ./development.nix
  ];

  system.stateVersion = "25.05";
}
