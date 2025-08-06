{
  config,
  ...
}:
{
  services.tailscale = {
    enable = true;

    authKeyFile = config.sops.secrets."tailscale/authkey".path;
  };

  sops.secrets."tailscale/authkey" = { };

  systemd.services.tailscaled-autoconnect = {
    after = [
      "sops-install-secrets.service"
    ];
    wants = [
      "sops-install-secrets.service"
    ];
  };
}
