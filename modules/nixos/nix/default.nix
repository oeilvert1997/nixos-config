{
  lib,
  ...
}:
{
  nix = {
    settings = {
      experimental-features = [
        "flakes"
        "nix-command"
      ];

      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://niri.cachix.org"
        # for T2Linux
        "https://cache.soopy.moe"
      ];

      trusted-substituters = [
        # for T2Linux
        "https://cache.soopy.moe"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        # for T2Linux
        "cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo="
      ];

      trusted-users = [
        "@wheel"
      ];

      auto-optimise-store = lib.mkDefault true;
    };

    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 7d";
    };
  };
}
