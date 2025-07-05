{
  mylib,
  ...
}:

{
  imports = builtins.concatLists [
    # (mylib.scanNixFilesRecursive ../core)
    [ ../core/boot.nix ]
    [ ../core/environment.nix ]
    [ ../core/i18n.nix ]
    [ ../core/networking.nix ]
    [ ../core/nix.nix ]
    [ ../core/nixpkgs.nix ]
    [ ../core/time.nix ]
    [ ../core/users.nix ]
    [ ./dm/tuigreet.nix ]
    [ ./statusbar/waybar.nix ]
    [ ./wm/hyprland.nix ]
  ];
}
