{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware.nix
  ];

  hardware.enableRedistributableFirmware = true;
  hardware.firmware = [ pkgs.linux-firmware ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [
    "amdgpu"
  ];

  programs.dconf.enable = true;

  system.stateVersion = "25.05";
}
