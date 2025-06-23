{ config, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  services.xserver = {
    enable = true;
  };

  security.polkit.enable = true;

  # Ensure graphical target is default
  systemd.defaultUnit = "graphical.target";

  # Greetd is lightweight and simple - no extra systemd services needed

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
