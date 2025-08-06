{
  pkgs,
  self,
  ...
}:
{
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  xdg.enable = true;

  home.packages = with pkgs; [
  ];

  imports = [
    "${self}/modules/home/gh.nix"
    "${self}/modules/home/git.nix"
  ];
}
