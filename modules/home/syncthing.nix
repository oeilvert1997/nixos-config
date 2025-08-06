{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.home.syncthing;
in
{
  options.modules.home.syncthing = {
    enable = lib.mkEnableOption "syncthing";

    guiAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0:8384";
      description = "Syncthing GUI listen address.";
    };

    guiUser = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Username for Syncthing GUI basic auth. Leave null to disable auth.";
    };

    guiPasswordFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Path to a file containing the GUI password.";
    };

    devices = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            id = lib.mkOption {
              type = lib.types.str;
              description = "Syncthing device ID of the remote device";
            };

            addresses = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [
                "dynamic"
              ];
              description = "Addresses to connect to.";
            };

            introducer = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to trust introductions of other devices made by this device.";
            };
          };
        }
      );
      default = { };
      description = "Remote Syncthing devices, keyed by a local name.";
    };

    folders = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            path = lib.mkOption {
              type = lib.types.str;
              description = "Local path of the shared folder.";
            };

            devices = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              description = "Names of devices (keys in `devices`) this folder is shared with.";
            };

            ignorePerms = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to ignore permission bit differences.";
            };

            versioning = lib.mkOption {
              type = lib.types.attrsOf lib.types.anything;
              default = {
                type = "trashcan";
                params.cleanoutDays = "30";
              };
              description = "File versioning configuration.";
            };
          };
        }
      );
      default = { };
      description = "Shared folders, keyed by a local name.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;

      tray.enable = false;

      inherit (cfg) guiAddress;

      overrideDevices = true;
      overrideFolders = true;

      guiCredentials = lib.mkIf (cfg.guiUser != null && cfg.guiPasswordFile != null) {
        username = cfg.guiUser;
        passwordFile = cfg.guiPasswordFile;
      };

      settings = {
        options = {
          globalAnnounceEnabled = false;
          relaysEnabled = false;
          localAnnounceEnabled = false;
          natEnabled = false;
        };

        devices = lib.mapAttrs (_: d: {
          inherit (d) id addresses introducer;
        }) cfg.devices;

        folders = lib.mapAttrs (_: f: {
          inherit (f)
            path
            devices
            ignorePerms
            versioning
            ;
        }) cfg.folders;
      };
    };
  };
}
