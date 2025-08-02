{
  ...
}:
{
  users.users.oeilvert = {
    isNormalUser = true;
    extraGroups  = [
      "networkmanager"
      "wheel"
    ];
  };

  imports = [
    ../../modules/nixos/boot.nix
    ../../modules/nixos/environment.nix
    ../../modules/nixos/i18n.nix
    ../../modules/nixos/networking.nix
    ../../modules/nixos/nix.nix
    ../../modules/nixos/time.nix
  ];
}
