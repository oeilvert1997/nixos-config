{
  pkgs,
  ...
}:

{
  networking = {
    hostName = "diva-00";
    networkmanager.enable = true;
  };
}
