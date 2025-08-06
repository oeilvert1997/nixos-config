{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    tree
    nix-output-monitor
  ];
}
