{
  username,
  ...
}:
{
  imports = [
    ./packages.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };
}
