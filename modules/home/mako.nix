{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    mako
  ];

  services.mako.enable = false;
}
