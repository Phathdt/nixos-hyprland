{ config, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.displayManager = {
    sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm;
      theme = "sddm-astronaut-theme";
      wayland.enable = true;
      settings = {
        Autologin = {
          # Uncomment these if you want autologin (not recommended for security)
          # User = "your-username";
          # Session = "hyprland";
        };
        General = {
          # Ensure Hyprland is detected
          HaltCommand = "/run/current-system/systemd/bin/systemctl poweroff";
          RebootCommand = "/run/current-system/systemd/bin/systemctl reboot";
        };
      };
    };
    defaultSession = "hyprland";
  };

  services.xserver = {
    enable = true;
  };

  security.polkit.enable = true;

  # Ensure graphical target is default
  systemd.defaultUnit = "graphical.target";

  # Additional systemd services
  systemd.services.sddm = {
    wants = [ "systemd-user-sessions.service" ];
    after = [ "systemd-user-sessions.service" "plymouth-quit-wait.service" ];
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
