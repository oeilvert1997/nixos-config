{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    brightnessctl
    ddcutil
    libnotify
    pamixer
    tree
    xdg-utils
  ];
}
