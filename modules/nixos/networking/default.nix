{
  hostname,
  lib,
  ...
}:
{
  networking.hostName = hostname;

  networking.useDHCP = lib.mkDefault true;
}
