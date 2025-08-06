{
  username,
  self,
  ...
}:
{
  imports = [
    ./hardware.nix
    ./disko.nix
    "${self}/modules/nixos/containers/librechat.nix"
    "${self}/modules/nixos/services/cloudflared.nix"
  ];

  modules.nixos.librechat = {
    enable = true;
    allowRegistration = true;
    externalInterface = "enp0s6";
    mcpFilesystemHostPath = "/home/${username}/repos";
  };

  # for librechat:
  # mcpFilesystemHostPath above requires this directory to exist.
  systemd.tmpfiles.rules = [
    "d /home/${username}/repos 0755 ${username} users -"
  ];

  modules.nixos.cloudflared = {
    enable = true;
    tunnelId = "ca8e8f66-2afd-4ecc-bb6a-68604965f2c4";
    ingress = {
      "librechat.balkenkreuz.com" = "http://10.0.17.2:3080";
    };
  };

  system.stateVersion = "26.05";
}
