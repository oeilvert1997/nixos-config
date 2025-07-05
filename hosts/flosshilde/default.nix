{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
in {
  imports = [
    ./hardware-configuration.nix
  ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "25.05";
}
