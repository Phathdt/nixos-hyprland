{ config, pkgs, ... }:

{
  # Environment variables for IBus to work properly in Wayland
  environment.sessionVariables = {
    GTK_IM_MODULE = "ibus";
    QT_IM_MODULE = "ibus";
    XMODIFIERS = "@im=ibus";
    GLFW_IM_MODULE = "ibus";
  };

  # Auto-start IBus daemon
  systemd.user.services.ibus-daemon = {
    description = "IBus Daemon";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.ibus}/bin/ibus-daemon --xim --daemonize --replace";
      Restart = "on-failure";
    };
  };
}
