{ config, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  users.users.phathdt.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCWWcTnrvaa8Zwf9n9B7nO6WMaxHRk+XRcpQQygPpxXyGW0m+8QvOv5mW4R1CcZID6Uy9Tbq/WylsfbuwkSbhf8Qd28FTGFQr9aI+ePFFjcwzzMZ3FtFuL+guq7K8v77N4VSNmm8V8F4/3fQzdSa0gSzAfqGKMsmTihScb5Q5N4lmVtxv3oUE2xmy/Yr9YphuGa79wL7nif6vBH6M8QuhecVXkMQD4lfIoNAbotP/Ac3ghC/U/62hoQZ+yHAOE+Ue83hGufv8FutgJIPGMYkQcOeJs7gd/5jLrrXfAD0ZO5jK6dELPXHsRrDL8R9ZlRMrLD6B7m37UVA3/gBq619qPLL4zbeuLjqi5ksv0gC3vdcAQ8dE7m2wj+kfdDR3Kh4Mxigb//p8TDL80XBfi7lgwYJyMx6FDqhUcu1Y7x2puipuCvp54ZhhlC6DvI3abROMr22e2je5icDtDRvdcgL5HJM8c+scmxAjoAwK7EkrT4PFiFYuqaMFFiAd3bGM71XKM= phathdt379@gmail.com"
  ];

  networking.firewall.allowedTCPPorts = [ 22 ];
}
