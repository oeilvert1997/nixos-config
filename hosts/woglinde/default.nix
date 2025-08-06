{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware.nix
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

  system.stateVersion = "26.05";
}
