{
  pkgs,
  ...
}:
{
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
    config = {
      common = {
        default = [
          # "wlr"
          # "gtk"
        ];
      };
      i3 = {
        default = [ "gtk" ];
      };
      hyprland = {
        default = [
          "hyprland"
          # "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        ];
      };
      niri = {
        default = [
          "wlr"
        ];
      };
    };
  };
}
