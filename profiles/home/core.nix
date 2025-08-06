{ pkgs, ... }:
{
  programs.home-manager.enable = true;

  xdg.enable = true;

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    brightnessctl
  ];

  imports = [
    ../../modules/home/btop.nix
    ../../modules/home/fastfetch.nix
    ../../modules/home/gh.nix
    ../../modules/home/git.nix
    ../../modules/home/neovim.nix
    ../../modules/home/tmux.nix
  ];
}
