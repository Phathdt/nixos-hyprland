{ config, pkgs, ... }:

{
  users.users.phathdt = {
    isNormalUser = true;
    description = "phathdt";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };
}
