{ config, pkgs, ... }:

{
  users.users.phathdt = {
    isNormalUser = true;
    description = "phathdt";
    extraGroups = [ "networkmanager" "wheel" "docker" "bluetooth" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };
}
