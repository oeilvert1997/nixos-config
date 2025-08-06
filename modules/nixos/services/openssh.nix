_: {
  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };

    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];

    openFirewall = false;
  };

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 22 ];
}
