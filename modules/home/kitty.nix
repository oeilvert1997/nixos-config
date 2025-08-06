{
  lib,
  ...
}:
{
  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;

      window_padding_width = "5 5";

      background_opacity = lib.mkForce 0.0;
    };
  };
}
