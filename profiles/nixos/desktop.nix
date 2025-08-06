{
  self,
  username,
  ...
}:
{
  imports = [
    "${self}/modules/nixos/hardware/bluetooth.nix"
    "${self}/modules/nixos/security/rtkit.nix"
    "${self}/modules/nixos/security/polkit.nix"
    "${self}/modules/nixos/services/pipewire.nix"
    "${self}/modules/nixos/services/upower.nix"
  ];

  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

  home-manager.users.${username}.imports = [
    "${self}/profiles/home/desktop.nix"
  ];
}
