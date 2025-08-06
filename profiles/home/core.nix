{
  self,
  ...
}:
{
  programs.home-manager.enable = true;

  home.stateVersion = "26.05";

  xdg.enable = true;

  imports = [
    "${self}/modules/home/btop.nix"
    "${self}/modules/home/cli-utils.nix"
    "${self}/modules/home/direnv.nix"
    "${self}/modules/home/editorconfig.nix"
    "${self}/modules/home/fastfetch.nix"
    "${self}/modules/home/fzf.nix"
    "${self}/modules/home/gh.nix"
    "${self}/modules/home/git.nix"
    "${self}/modules/home/nixvim.nix"
    "${self}/modules/home/ssh-agent.nix"
    "${self}/modules/home/tmux.nix"
    "${self}/modules/home/xdg.nix"
    "${self}/modules/home/yazi.nix"
    "${self}/modules/home/zsh.nix"
  ];
}
