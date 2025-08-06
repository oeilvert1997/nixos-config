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

      cursor_trail = 1;
      cursor_trail_decay = "0.01 0.1";
      cursor_trail_start_threshold = 8;
    };
  };
}
