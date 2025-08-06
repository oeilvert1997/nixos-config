{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.apple-t2
  ];

  hardware.enableRedistributableFirmware = true;
  hardware.firmware = [ pkgs.linux-firmware ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.i2c.enable = true;

  # services.xserver.videoDrivers = [
  #   "amdgpu"
  # ];

  programs.dconf.enable = true;

  system.stateVersion = "25.11";
}
