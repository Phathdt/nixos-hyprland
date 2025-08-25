{ config, pkgs, ... }:

{
  programs.zsh.enable = true;

  programs.nix-ld.enable = true;

  # AppImage support
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
