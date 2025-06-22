{ config, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "sddm-astronaut";
    settings = {
      Theme = {
        Current = "sddm-astronaut";
        CursorTheme = "Bibata-Modern-Classic";
        Font = "JetBrainsMono Nerd Font";
      };
      General = {
        InputMethod = "qtvirtualkeyboard";
      };
    };
  };

  services.xserver = {
    enable = true;
  };

  security.polkit.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
