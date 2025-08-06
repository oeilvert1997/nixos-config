{
  pkgs,
  self,
  username,
  ...
}:
{
  imports = [
    ./hardware.nix
    "${self}/modules/nixos/containers/librechat.nix"
  ];

  hardware = {
    enableRedistributableFirmware = true;
    firmware = [ pkgs.linux-firmware ];
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    i2c.enable = true;
  };

  services.xserver.videoDrivers = [
    "amdgpu"
  ];

  programs.dconf.enable = true;

  modules.nixos.librechat = {
    enable = true;
    allowRegistration = true;
    externalInterface = "enp13s0";
    mcpFilesystemPaths = {
      vault = {
        path = "/home/${username}/Documents/obsidian";
        isReadOnly = true;
        owner = username;
        group = "users";
      };
      repos = {
        path = "/home/${username}/repos";
        isReadOnly = true;
        owner = username;
        group = "users";
      };
    };
  };

  # for syncthing
  networking.firewall.interfaces."tailscale0" = {
    allowedTCPPorts = [
      8384
      22000
    ];
    allowedUDPPorts = [
      22000
    ];
  };

  system.stateVersion = "26.05";
}
