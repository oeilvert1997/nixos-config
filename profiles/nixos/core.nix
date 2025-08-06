{ ... }:
{
  nixpkgs.config.allowUnfree = true;

  imports = [
    ../../modules/nixos/boot/console-log.nix
    ../../modules/nixos/boot/systemd-boot.nix
    ../../modules/nixos/environment/packages.nix
    ../../modules/nixos/hardware/bluetooth.nix
    ../../modules/nixos/hardware/firmware.nix
    ../../modules/nixos/i18n/default.nix
    ../../modules/nixos/networking/default.nix
    ../../modules/nixos/networking/networkmanager.nix
    ../../modules/nixos/nix/default.nix
    ../../modules/nixos/time/default.nix
    ../../modules/nixos/users/oeilvert.nix
  ];
}
