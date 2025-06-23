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
        # Enable all audio profiles
        Class = "0x000100";
        # Auto-enable audio profiles
        AutoEnable = true;
      };
      Policy = {
        AutoEnable = true;
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
    # Enable Bluetooth audio support
    wireplumber.enable = true;
  };

  # Additional audio packages for Bluetooth
  environment.systemPackages = with pkgs; [
    # Bluetooth audio tools
    bluez-tools
    bluez-alsa
    # Audio control tools
    wireplumber
    # GUI tools
    pavucontrol
  ];

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

  # Tailscale VPN
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    # Auto-connect on boot (requires auth key setup)
    extraUpFlags = [ "--accept-routes" "--accept-dns" ];
  };

  # NetworkManager with VPN support - moved to networking.nix to avoid conflicts
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-openvpn
      networkmanager-vpnc
      networkmanager-l2tp
    ];
    # Don't override DNS when using VPN
    dns = "systemd-resolved";
    # Enable connection sharing
    unmanaged = [ "docker0" "virbr0" ];
  };

    # Disable IPv6 completely for VPN compatibility
  networking.enableIPv6 = false;

  # Additional IPv6 disable via kernel parameters
  boot.kernelParams = [
    "ipv6.disable=1"
  ];
}
