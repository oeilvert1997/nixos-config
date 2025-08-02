{
  lib,
  pkgs,
  ...
}:
{
  home = {
    username = lib.mkDefault "root";
    homeDirectory = lib.mkDefault "/root";
    stateVersion = "25.05";
  };
}
