{ pkgs, ... }:
{
  home.username = "oeilvert";
  home.homeDirectory = "/home/oeilvert";

  home.packages = with pkgs; [
    neofetch
  ];

  home.stateVersion = "25.05";
}
