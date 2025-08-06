{
  config,
  inputs,
  osConfig,
  username,
  ...
}:
{
  modules.home = {
    #   hyprland = {
    #     enable = true;

    #     monitor = [ ",preferred,auto,1.0" ];
    #   };

    stylix = {
      enable = true;

      image = inputs.wallpapers + "/gekkou_3840x2160.png";
    };

    syncthing = {
      enable = true;

      guiAddress = "0.0.0.0:8384";

      guiUser = username;

      guiPasswordFile = osConfig.sops.secrets."syncthing/gui-password".path;

      cert = osConfig.sops.secrets."syncthing/cert".path;
      key = osConfig.sops.secrets."syncthing/key".path;

      devices = {
        rhein = {
          id = "2UCHOYX-2762NLH-YER6V3A-C64XBQC-X4RCLG3-ZF3LYGY-PBBXRHR-HUR53AW";
          addresses = [
            "tcp://rhein.tail75e611.ts.net:22000"
          ];
        };
        android = {
          id = "CYHYJEG-DXRWMGK-HLL3SWK-HOAMLCY-D4WJ4F5-F3PTPNY-VGYTJ6F-JS7TPAB";
          addresses = [
            "tcp://nothing-phone.tail75e611.ts.net:22000"
          ];
        };
      };

      folders = {
        vault = {
          path = "${config.home.homeDirectory}/Documents/obsidian";
          devices = [
            "rhein"
            "android"
          ];
          ignorePerms = true;
        };
      };
    };
  };
}
