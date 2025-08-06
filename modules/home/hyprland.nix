{
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = false;

    package = null;
    portalPackage = null;
  };

  home.packages = with pkgs; [
    # hyprpicker
    # hyprsysteminfo
    # hyprland-qt-support
    # wl-clipboard
  ];

  # services.hyprpaper.enable = true;
  # services.hypridle.enable = true;
  # services.hyprsunset.enable = true;
  # services.hyprpolkitagent.enable = true;
  # services.cliphist.enable = true;

  # programs.hyprlock.enable = true;
  # programs.ranger.enable = true;
}
