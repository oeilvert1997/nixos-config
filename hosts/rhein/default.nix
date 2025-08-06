{
  hostname,
  inputs,
  self,
  username,
  ...
}:
{
  imports = [
    ./hardware.nix
    ./disko.nix
    "${self}/modules/nixos/containers/librechat.nix"
    "${self}/modules/nixos/services/cloudflared.nix"
  ];

  sops.secrets = {
    "syncthing/cert" = {
      sopsFile = "${inputs.nixos-secrets}/hosts/${hostname}.yaml";
      owner = username;
      mode = "0400";
    };
    "syncthing/key" = {
      sopsFile = "${inputs.nixos-secrets}/hosts/${hostname}.yaml";
      owner = username;
      mode = "0400";
    };
  };

  users.users.${username}.linger = true;

  modules.nixos.librechat = {
    enable = true;
    allowRegistration = true;
    externalInterface = "enp0s6";
    cloudflare = {
      accountId = "5be06416a555206cac3b020416c586e7";
      gatewayId = "librechat";
    };
    backup = {
      enable = true;
      onCalendar = "03:00";
      localRetentionDays = 3;
    };
    tailnetForwards.filesystem-woglinde = {
      port = 8765;
      target = "woglinde.tail75e611.ts.net:8765";
    };
    mcpServers.filesystem-woglinde = {
      type = "sse";
      url = "http://10.0.17.1:8765/sse";
      chatMenu = true;
    };
  };

  modules.nixos.cloudflared = {
    enable = true;
    tunnelId = "76e0493a-d654-49c7-8645-8bdf454f1ea6";
    ingress = {
      "librechat.balkenkreuz.com" = "http://10.0.17.2:3080";
    };
  };

  # for Syncthing
  networking.firewall.interfaces."tailscale0" = {
    allowedTCPPorts = [
      22000
    ];
  };

  system.stateVersion = "26.05";
}
