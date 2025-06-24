{ config, pkgs, ... }:

{
  programs.zsh.enable = true;

  # AppImage support
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
