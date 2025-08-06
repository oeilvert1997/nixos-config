{
  config,
  pkgs,
  ...
}:
{
  users.users.oeilvert = {
    hashedPasswordFile = config.sops.secrets."user/password_hash".path;
    isNormalUser = true;
    extraGroups = [
      "i2c"
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIU5ZpZcRU3EwBtvNKifj2mSSfhk8KIJQIHIkSX1mqCb"
    ];
  };

  programs.zsh.enable = true;
}
