{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    brightnessctl
    libnotify
    tree
  ];
}
