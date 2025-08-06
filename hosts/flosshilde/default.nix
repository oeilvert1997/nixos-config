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

  hardware.firmware = [
    pkgs.linux-firmware
  ];

  # Disable wifi
  # networking.networkmanager.unmanaged = [ "interface-name:wlp115s0f0" ];
  # systemd.services.wpa_supplicant.enable = false;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.i2c.enable = true;

  programs.dconf.enable = true;

  system.stateVersion = "25.11";
}
