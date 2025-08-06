{
  self,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

  imports = [
    "${self}/modules/nixos/boot/systemd-boot.nix"
    "${self}/modules/nixos/environment/default.nix"
    "${self}/modules/nixos/i18n/default.nix"
    "${self}/modules/nixos/networking/default.nix"
    "${self}/modules/nixos/networking/networkmanager.nix"
    "${self}/modules/nixos/nix/default.nix"
    "${self}/modules/nixos/time/default.nix"
    "${self}/modules/nixos/users/oeilvert.nix"
  ];
}
