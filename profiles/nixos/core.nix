{
  inputs,
  self,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko

    "${self}/modules/nixos/services/sops.nix"

    "${self}/modules/nixos/boot/kernel.nix"
    "${self}/modules/nixos/boot/loader.nix"
    "${self}/modules/nixos/environment/default.nix"
    "${self}/modules/nixos/i18n/default.nix"
    "${self}/modules/nixos/networking/default.nix"
    "${self}/modules/nixos/networking/networkmanager.nix"
    "${self}/modules/nixos/nix/default.nix"
    "${self}/modules/nixos/programs/ssh.nix"
    "${self}/modules/nixos/services/openssh.nix"
    "${self}/modules/nixos/services/resolve.nix"
    "${self}/modules/nixos/services/tailscale.nix"
    "${self}/modules/nixos/time/default.nix"
    "${self}/modules/nixos/users/default.nix"
    "${self}/modules/nixos/users/home.nix"
  ];
}
