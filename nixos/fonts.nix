{ config, pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      fira-code
      source-code-pro
      noto-fonts
      noto-fonts-emoji
      jetbrains-mono
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Fira Code" ];
      };
    };
  };
}
