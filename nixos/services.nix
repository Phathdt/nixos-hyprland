{ config, pkgs, ... }:

{
  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  services.blueman.enable = true;

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Power management
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # Printing
  services.printing.enable = true;

  # Location services
  services.geoclue2.enable = true;

  # Virtualization
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # NetworkManager VPN plugins
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-openvpn
      networkmanager-openconnect
    ];
  };
}
