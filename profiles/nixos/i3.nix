{
  self,
  ...
}:
{
  imports = [
    "${self}/modules/nixos/wm/i3.nix"
    "${self}/modules/nixos/security/rtkit.nix"
    "${self}/modules/nixos/security/polkit.nix"
    "${self}/modules/nixos/services/pipewire.nix"
    "${self}/modules/nixos/services/upower.nix"
  ];
}
