{
  lib,
  pkgs,
  ...
}:

{
  nix.settings = {
    experimental-features = [ "flakes" "nix-command" ];
    substituters = [
      "https://cache.nixos.org"
    ];
    auto-optimise-store = lib.mkDefault true;
  };

  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };
}
