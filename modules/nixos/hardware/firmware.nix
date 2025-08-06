{
  pkgs,
  ...
}:
{
  hardware.firmware = with pkgs; [ linux-firmware ];
}
