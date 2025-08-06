{
  ...
}:
{
  imports = [
    ./hardware.nix
  ];

  hardware.bluetooth.enable = true;

  system.stateVersion = "25.05";
}
