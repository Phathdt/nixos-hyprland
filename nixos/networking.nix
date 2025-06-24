{ config, pkgs, ... }:

{
  networking.hostName = "nixos";

  # Homelab hosts
  networking.hosts = {
    "127.0.0.1" = [
      "homelab.local"
      "traefik.homelab.local"
      "immich.homelab.local"
      "portainer.homelab.local"
      "netdata.homelab.local"
    ];
  };

  # DNS configuration for better VPN compatibility
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" "8.8.4.4" ];
  networking.dhcpcd.extraConfig = "nohook resolv.conf";

  # Enable systemd-resolved for better DNS handling
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };
}
