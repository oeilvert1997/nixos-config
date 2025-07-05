{
  pkgs,
  ...
}:

{
  users.users.oeilvert = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      foot
    ];
  };
}
