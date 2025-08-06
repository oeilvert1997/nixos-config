{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    wofi
  ];

  programs.wofi.enable = false;
}
