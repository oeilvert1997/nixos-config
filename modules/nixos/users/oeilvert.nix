{
  pkgs,
  ...
}:
{
  users.users.oeilvert = {
    isNormalUser = true;
    extraGroups = [
      "i2c"
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}
