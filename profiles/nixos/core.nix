{ pkgs, ... }:
{
  imports = [
    ../../modules/nixos/boot.nix
    ../../modules/nixos/environment.nix
    ../../modules/nixos/i18n.nix
    ../../modules/nixos/networking.nix
    ../../modules/nixos/nix.nix
    ../../modules/nixos/time.nix
    ../../modules/nixos/users.nix
  ];
}
