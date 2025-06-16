{ config, pkgs, ... }:

{
  # Environment variables for Fcitx5
  environment.sessionVariables = {
    GTK_IM_MODULE = "fcitx5";
    QT_IM_MODULE = "fcitx5";
    XMODIFIERS = "@im=fcitx5";
    INPUT_METHOD = "fcitx5";
  };

  # Auto-start Fcitx5
  systemd.user.services.fcitx5-daemon = {
    description = "Fcitx5 input method editor";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.fcitx5}/bin/fcitx5";
      Restart = "on-failure";
    };
  };
}
