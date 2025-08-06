{
  config,
  osConfig,
  username,
  ...
}:
{
  modules.home = {
    syncthing = {
      enable = true;

      guiAddress = "127.0.0.1:8384";

      guiUser = username;

      guiPasswordFile = osConfig.sops.secrets."syncthing/gui-password".path;

      cert = osConfig.sops.secrets."syncthing/cert".path;
      key = osConfig.sops.secrets."syncthing/key".path;

      devices = {
        woglinde = {
          id = "BIF2JDJ-ZR4MER3-3ZBTORP-7QIGMR4-5T5BCCZ-WROKYJA-GOX7X64-CEIZHAZ";
          addresses = [
            "tcp://woglinde.tail75e611.ts.net:22000"
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
            "woglinde"
            "android"
          ];
          ignorePerms = true;
        };
      };
    };
  };
}
