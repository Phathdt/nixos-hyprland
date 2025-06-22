{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (pkgs.callPackage ./sddm-astronaut-theme.nix {
      theme = "black_hole";
      themeConfig = {
        General = {
          HeaderText = "Hi Boss";
          Background = "~/.config/sddm/black_hole.jpg";
          FontSize = "12.0";
          ScreenWidth = "1920";
          ScreenHeight = "1080";
        };
        Design = {
          MainColor = "#c792ea";
          AccentColor = "#82aaff";
          BackgroundColor = "#292d3e";
          OverrideLoginButtonTextColor = "#eeffff";
          Font = "JetBrainsMono Nerd Font";
        };
      };
    })
    sddm-sugar-dark  # Backup theme để test
  ];
}
