{
  config,
  pkgs,
  ...
}:
{
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  home.packages = with pkgs; [
    hyprland
    hyprpicker
    hyprsysteminfo
    hyprland-qt-support
    wl-clipboard
  ];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  # services.hyprpaper.enable = true;
  # services.hypridle.enable = true;
  # services.hyprsunset.enable = true;
  # services.hyprpolkitagent.enable = true;
  # services.cliphist.enable = true;

  # programs.hyprlock.enable = true;
  # programs.ranger.enable = true;

  xdg.configFile."hypr" =
    let
      mkSymlink = config.lib.file.mkOutOfStoreSymlink;
      configPath = "${config.home.homeDirectory}/nixos-config/config/hypr";
    in
    {
      source = mkSymlink configPath;
    };
}
