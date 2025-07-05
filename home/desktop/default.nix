{
  mylib,
  ...
}:

{
  home = {
    username = "oeilvert";
    homeDirectory = "/home/oeilvert";
    stateVersion = "25.05";
  };

  imports = builtins.concatLists [
    # (mylib.scanNixFilesRecursive ../core)
    [ ../core/git/default.nix ]
    [ ./alacritty/default.nix ]
  ];
}
