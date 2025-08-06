{
  hostname,
  inputs,
  pkgs,
  self,
  username,
  ...
}:
{
  imports = [
    ./hardware.nix
    ./disko.nix
    ./preservation.nix
    "${self}/modules/nixos/services/filesystem-mcp-proxy.nix"
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

  programs.dconf.enable = true;

  modules.nixos.filesystemMcpProxy = {
    enable = true;
    paths = [
      "/home/${username}/nixos-config"
    ];
    isReadOnly = true;
    user = username;
    group = "users";
  };

  # for Syncthing
  networking.firewall.interfaces."tailscale0" = {
    allowedTCPPorts = [
      8384
      22000
    ];
  };

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  system.stateVersion = "26.05";
}
