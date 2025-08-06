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

      guiUser = username;

      guiPasswordFile = osConfig.sops.secrets."syncthing/gui-password".path;

      devices = {
        android = {
          id = "CYHYJEG-DXRWMGK-HLL3SWK-HOAMLCY-D4WJ4F5-F3PTPNY-VGYTJ6F-JS7TPAB";
          addresses = [
            "tcp://100.73.194.41:22000"
          ];
        };
      };

      folders = {
        vault = {
          path = "${config.home.homeDirectory}/Documents/obsidian";
          devices = [
            "android"
          ];
          ignorePerms = true;
        };
      };
    };
  };
}
