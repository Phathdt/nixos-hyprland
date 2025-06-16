{ config, pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      fira-code
      source-code-pro
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      jetbrains-mono
      nerd-fonts.jetbrains-mono
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" "JetBrains Mono" "Fira Code" ];
      };
    };
  };
}
