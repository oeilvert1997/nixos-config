{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    firefox
  ];

  programs.firefox.enable = false;
}
