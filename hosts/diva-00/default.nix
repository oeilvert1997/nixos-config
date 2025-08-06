{
  ...
}:
{
  imports = [
    ./hardware.nix
  ];

  hardware.bluetooth.enable = false;

  virtualisation.vmware.guest.enable = true;

  system.stateVersion = "25.05";
}
