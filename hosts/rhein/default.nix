{
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

  modules.nixos.librechat = {
    enable = true;
    allowRegistration = true;
    externalInterface = "enp0s6";
    mcpFilesystemPaths = {
      vault = {
        path = "/home/${username}/Documents/obsidian";
        isReadOnly = true;
        owner = username;
        group = "users";
      };
    };
  };

  modules.nixos.cloudflared = {
    enable = true;
    tunnelId = "76e0493a-d654-49c7-8645-8bdf454f1ea6";
    ingress = {
      "librechat.balkenkreuz.com" = "http://10.0.17.2:3080";
    };
  };

  system.stateVersion = "26.05";
}
