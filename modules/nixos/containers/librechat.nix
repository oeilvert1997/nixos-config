{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.nixos.librechat;

  mcpFilesystemContainerPath = "/mnt/mcp-filesystem";
in
{
  options.modules.nixos.librechat = {
    enable = lib.mkEnableOption "librechat container";

    allowRegistration = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to allow new user registration in LibreChat.";
    };

    externalInterface = lib.mkOption {
      type = lib.types.str;
      description = "The host network interface for NAT (e.g. enp13s0, eth0)";
    };

    mcpFilesystemPaths = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            path = lib.mkOption {
              type = lib.types.path;
              description = "Host directory to expose to the filesystem MCP server.";
            };
            isReadOnly = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether this directory is mounted read-only in the container.";
            };
            owner = lib.mkOption {
              type = lib.types.str;
              default = "root";
              description = "Owner of the host directory (used for the generated tmpfiles rule).";
            };
            group = lib.mkOption {
              type = lib.types.str;
              default = "root";
              description = "Group of the host directory (used for the generated tmpfiles rule).";
            };
          };
        }
      );
      default = { };
      description = "Mapping of name to host directory configuration exposed to the filesystem MCP server.";
    };

    backup = {
      enable = lib.mkEnableOption "periodic local mongodump snapshots of the LibreChat database.";

      onCalendar = lib.mkOption {
        type = lib.types.str;
        default = "03:00";
        description = "systemd OnCalendar expression for the mongodump timer inside the container.";
      };

      localRetentionDays = lib.mkOption {
        type = lib.types.int;
        default = 3;
        description = "How many days of mongodump snapshots to keep on the host";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services."container@librechat" = {
      after = [
        "sops-install-secrets.service"
      ];

      wants = [
        "sops-install-secrets.service"
      ];
    };

    systemd.tmpfiles.rules =
      (lib.mapAttrsToList (
        _: pathCfg: "d ${pathCfg.path} 0755 ${pathCfg.owner} ${pathCfg.group} -"
      ) cfg.mcpFilesystemPaths)
      ++ lib.optional cfg.backup.enable "d /var/lib/librechat-backups 0750 root root -";

    networking.nat = {
      enable = true;

      internalInterfaces = [
        "ve-librechat"
      ];

      inherit (cfg) externalInterface;
    };

    containers.librechat = {
      autoStart = true;

      privateNetwork = true;
      hostAddress = "10.0.17.1";
      localAddress = "10.0.17.2";

      bindMounts = {
        "/run/secrets/librechat.env" = {
          hostPath = config.sops.templates."librechat.env".path;
          isReadOnly = true;
        };
      }
      // lib.mapAttrs' (
        name: pathCfg:
        lib.nameValuePair "${mcpFilesystemContainerPath}/${name}" {
          hostPath = pathCfg.path;
          inherit (pathCfg) isReadOnly;
        }
      ) cfg.mcpFilesystemPaths
      // lib.optionalAttrs cfg.backup.enable {
        "/var/backups/librechat" = {
          hostPath = "/var/lib/librechat-backups";
          isReadOnly = false;
        };
      };

      config = { pkgs, ... }: {
        nixpkgs.config.allowUnfree = true;

        services.librechat = {
          enable = true;

          enableLocalDB = true;

          openFirewall = true;

          credentialsFile = "/run/secrets/librechat.env";

          env = {
            PORT = 3080;
            HOST = "0.0.0.0";
            ALLOW_REGISTRATION = cfg.allowRegistration;
            GOOGLE_KEY = "\${GOOGLE_KEY}";
            # [PR:563577 Pending] Remove MONGO_URI
            MONGO_URI = lib.mkForce "mongodb://127.0.0.1:27017/LibreChat";
          };

          settings = {
            version = "1.3.12";

            endpoints = {
              google = {
                apiKey = "\${GOOGLE_KEY}";
                models = {
                  fetch = true;
                };
              };
            };

            mcpServers = {
              filesystem = {
                command = "${pkgs.mcp-server-filesystem}/bin/mcp-server-filesystem";
                args = map (name: "${mcpFilesystemContainerPath}/${name}") (
                  builtins.attrNames cfg.mcpFilesystemPaths
                );
              };

              fetch = {
                command = "${pkgs.mcp-server-fetch}/bin/mcp-server-fetch";
                args = [ ];
              };

              nixos = {
                command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
                args = [ ];
              };
            };
          };
        };

        systemd.services.librechat-mongodump = lib.mkIf cfg.backup.enable {
          description = "Dump the librechat MongoDB database";
          after = [
            "mongodb.service"
          ];

          serviceConfig.Type = "oneshot";

          script = ''
            set -euo pipefail

            ts="$(date +%Y%m%d-%H%M%S)"
            outdir="/var/backups/librechat/$ts"
            mkdir -p "$outdir"

            ${pkgs.mongodb-tools}/bin/mongodump \
              --uri="mongodb://127.0.0.1:27017/LibreChat" \
              --gzip \
              --out="$outdir"

            ln -sfn "$outdir" /var/backups/librechat/latest

            find /var/backups/librechat -mindepth 1 -maxdepth 1 -type d \
              -mtime +${toString cfg.backup.localRetentionDays} -exec rm -rf {} +
          '';
        };

        systemd.timers.librechat-mongodump = lib.mkIf cfg.backup.enable {
          wantedBy = [
            "timers.target"
          ];
          timerConfig = {
            OnCalendar = cfg.backup.onCalendar;
            Persistent = true;
          };
        };

        networking = {
          useHostResolvConf = false;

          nameservers = [
            "1.1.1.1"
            "8.8.8.8"
          ];
        };

        system.stateVersion = "26.05";
      };
    };
  };
}
