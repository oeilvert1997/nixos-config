_: {
  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };

    openFirewall = false;
  };

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 22 ];
}
