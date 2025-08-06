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
    (pkgs.runCommand "macbook-firmware" { } ''
      mkdir -p $out/lib/firmware/brcm
      ${pkgs.gnutar}/bin/tar -xvf ${./firmware.tar} -C $out/lib/firmware/brcm
    '')
  ];

  # Disable wifi
  networking.networkmanager.unmanaged = [ "interface-name:wlp115s0f0" ];
  systemd.services.wpa_supplicant.enable = false;

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
