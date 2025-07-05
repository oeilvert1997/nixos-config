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

  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  virtualisation.vmware.guest.enable = true;

  system.stateVersion = "25.05";
}
