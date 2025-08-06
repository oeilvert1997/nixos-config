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
    wl-clipboard
    xdg-utils
  ];
}
