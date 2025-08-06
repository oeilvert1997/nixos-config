{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    git
    mozc
    vim
  ];
}
