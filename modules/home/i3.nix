{
  pkgs,
  self,
  ...
}:
{
  xsession = {
    enable = true;
    scriptPath = ".xinitrc";
    profileExtra = ''
      systemctl --user import-environment DISPLAY XAUTHORITY
    '';
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = {
        modifier = "Mod4";
        gaps = {
          inner = 10;
          outer = 5;
        };
      };
    };
  };

  services.clipmenu.enable = true;

  xdg.configFile."i3" = {
    source = "${self}/config/i3";
    recursive = true;
  };
}
