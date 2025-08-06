{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    brightnessctl
    tree
  ];
}
