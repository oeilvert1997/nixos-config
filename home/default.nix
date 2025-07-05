{
  config,
  pkgs,
  ...
}:

{
  home.username = "oeilvert";
  home.homeDirectory = "/home/oeilvert";

  home.packages = with pkgs; [
    kitty
    neofetch
  ];

  programs.git = {
    enable = true;
    userName = "oeilvert";
    userEmail = "oeilvert@nixos.com";
  };

  # home.file.".gitconfig".source = ../config/git/.gitconfig

  home.stateVersion = "25.05";
}
