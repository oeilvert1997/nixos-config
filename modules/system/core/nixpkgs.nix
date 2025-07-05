{
  lib,
  pkgs,
  ...
}:

{
  nixpkgs.config.allowUnfree = lib.mkForce true;
}
