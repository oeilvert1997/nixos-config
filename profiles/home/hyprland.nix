{
  self,
  ...
}:
{
  imports = [
    "${self}/modules/home/firefox.nix"
    "${self}/modules/home/fontconfig.nix"
    "${self}/modules/home/hyprland.nix"
    "${self}/modules/home/kitty.nix"
    "${self}/modules/home/waybar.nix"
    "${self}/modules/home/wofi.nix"
  ];
}
