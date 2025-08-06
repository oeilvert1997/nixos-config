{
  inputs,
  hostname,
  self,
  ...
}:
{
  imports = [
    inputs.niri.homeModules.niri
    inputs.nix-colors.homeManagerModules.default
    inputs.stylix.homeModules.stylix

    "${self}/hosts/${hostname}/home.nix"

    "${self}/modules/home/alacritty.nix"
    # "${self}/modules/home/bitwarden.nix"
    "${self}/modules/home/colors.nix"
    "${self}/modules/home/desktop-utils.nix"
    "${self}/modules/home/fcitx5.nix"
    "${self}/modules/home/firefox.nix"
    "${self}/modules/home/fontconfig.nix"
    "${self}/modules/home/gimp.nix"
    "${self}/modules/home/kitty.nix"
    "${self}/modules/home/mako.nix"
    "${self}/modules/home/mpv.nix"
    "${self}/modules/home/niri.nix"
    "${self}/modules/home/obsidian.nix"
    "${self}/modules/home/quickshell.nix"
    "${self}/modules/home/stylix.nix"
    "${self}/modules/home/vscode.nix"
    "${self}/modules/home/waybar.nix"
    "${self}/modules/home/wofi.nix"
    "${self}/modules/home/wpaperd.nix"
    "${self}/modules/home/xdg-portal.nix"
  ];
}
