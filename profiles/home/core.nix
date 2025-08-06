{
  pkgs,
  ...
}:
{
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  xdg.enable = true;

  home.packages = with pkgs; [
  ];

  imports = [
    ../../modules/home/gh.nix
    ../../modules/home/git.nix
  ];
}
