{
  config,
  lib,
  pkgs,
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

    mcpServers = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Extra entries merged into librechat.yaml's mcpServers.";
    };

    tailnetForwards = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            port = lib.mkOption {
              type = lib.types.port;
              description = "Port the host listens on; reachable from the container at the host address.";
            };
            target = lib.mkOption {
              type = lib.types.str;
              description = "Upstream host:port on the tailnet (resolved on the host).";
            };
          };
        }
      );
      default = { };
      description = "TCP relays from the container to tailnet services via the host.";
    };

    cloudflare = {
      accountId = lib.mkOption {
        type = lib.types.str;
        description = "Cloudflare Account ID (for Workers AI / AI Gateway).";
      };

      gatewayId = lib.mkOption {
        type = lib.types.str;
        default = "default";
        description = "AI Gateway ID/name to route Workers AI requests through.";
      };
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
    sops = {
      secrets = {
        "librechat/jwt-secret" = { };
        "librechat/jwt-refresh-secret" = { };
        "librechat/creds-key" = { };
        "librechat/creds-iv" = { };
        "api-keys/anthropic/default" = { };
        "api-keys/cloudflare/ai-gateway" = { };
        "api-keys/cloudflare/workers-ai" = { };
        "api-keys/google/gemini" = { };
        "api-keys/openai/default" = { };
      };

      templates."librechat.env" = {
        restartUnits = [
          "container@librechat.service"
        ];

        content = ''
          JWT_SECRET=${config.sops.placeholder."librechat/jwt-secret"}
          JWT_REFRESH_SECRET=${config.sops.placeholder."librechat/jwt-refresh-secret"}
          CREDS_KEY=${config.sops.placeholder."librechat/creds-key"}
          CREDS_IV=${config.sops.placeholder."librechat/creds-iv"}
          ANTHROPIC_API_KEY=${config.sops.placeholder."api-keys/anthropic/default"}
          CF_AI_GATEWAY_TOKEN=${config.sops.placeholder."api-keys/cloudflare/ai-gateway"}
          CF_WORKERS_AI_TOKEN=${config.sops.placeholder."api-keys/cloudflare/workers-ai"}
          GOOGLE_KEY=${config.sops.placeholder."api-keys/google/gemini"}
          OPENAI_API_KEY=${config.sops.placeholder."api-keys/openai/default"}
        '';
      };
    };

    systemd.services = {
      "container@librechat" = {
        after = [
          "sops-install-secrets.service"
          "systemd-machined.socket"
        ];

        wants = [
          "sops-install-secrets.service"
          "systemd-machined.socket"
        ];
      };
    }
    // lib.mapAttrs' (
      name: fwd:
      lib.nameValuePair "librechat-forward-${name}" {
        description = "Relay librechat container -> ${fwd.target}";
        after = [
          "tailscaled.service"
        ];
        wants = [
          "tailscaled.service"
        ];
        wantedBy = [
          "multi-user.target"
        ];

        serviceConfig = {
          ExecStart = "${pkgs.socat}/bin/socat TCP-LISTEN:${toString fwd.port},fork,reuseaddr TCP:${fwd.target}";
          DynamicUser = true;
          Restart = "always";
          RestartSec = 5;
        };
      }
    ) cfg.tailnetForwards;

    systemd.tmpfiles.rules =
      (lib.mapAttrsToList (
        _: pathCfg: "d ${pathCfg.path} 0755 ${pathCfg.owner} ${pathCfg.group} -"
      ) cfg.mcpFilesystemPaths)
      ++ lib.optional cfg.backup.enable "d /var/lib/librechat-backups 0750 root root -";

    networking = {
      nat = {
        enable = true;

        internalInterfaces = [
          "ve-librechat"
        ];

        inherit (cfg) externalInterface;
      };

      firewall.interfaces."ve-librechat".allowedTCPPorts = lib.mapAttrsToList (
        _: fwd: fwd.port
      ) cfg.tailnetForwards;
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

          # [PR:564312] Add localDB.enable/localDB.name options
          # -enableLocalDB = true;
          # + localDB.enable = true;
          # + localDB.name = "LibreChat";
          enableLocalDB = true;

          openFirewall = true;

          credentialsFile = "/run/secrets/librechat.env";

          env = {
            PORT = 3080;
            HOST = "0.0.0.0";
            ALLOW_REGISTRATION = cfg.allowRegistration;
            ANTHROPIC_API_KEY = "\${ANTHROPIC_API_KEY}";
            CF_AI_GATEWAY_TOKEN = "\${CF_AI_GATEWAY_TOKEN}";
            CF_WORKERS_AI_TOKEN = "\${CF_WORKERS_AI_TOKEN}";
            CF_ACCOUNT_ID = cfg.cloudflare.accountId;
            CF_GATEWAY_ID = cfg.cloudflare.gatewayId;
            GOOGLE_KEY = "\${GOOGLE_KEY}";
            OPENAI_API_KEY = "\${OPENAI_API_KEY}";
            # [PR:564312] Add localDB.enable/localDB.name options
            # - MONGO_URI = lib.mkForce "mongodb://127.0.0.1:27017/LibreChat";
            MONGO_URI = lib.mkForce "mongodb://127.0.0.1:27017/LibreChat";

            # Enabled Models
            # ANTHROPIC_MODELS = "";
            # OPENAI_MODELS = "";
          };

          settings = {
            version = "1.3.12";

            mcpSettings.allowedAddresses = lib.mapAttrsToList (
              _: fwd: "10.0.17.1:${toString fwd.port}"
            ) cfg.tailnetForwards;

            endpoints = {
              google = {
                apiKey = "\${GOOGLE_KEY}";
                models = {
                  fetch = true;
                };
              };

              custom = [
                {
                  name = "Cloudflare Workers AI";
                  apiKey = "\${CF_WORKERS_AI_TOKEN}";
                  baseURL = "https://gateway.ai.cloudflare.com/v1/\${CF_ACCOUNT_ID}/\${CF_GATEWAY_ID}/workers-ai/v1";
                  headers = {
                    "cf-aig-authorization" = "Bearer \${CF_AI_GATEWAY_TOKEN}";
                  };
                  models = {
                    default = [
                      "@cf/zai-org/glm-5.3-flash"
                      "@cf/zai-org/glm-4.7-flash"
                    ];
                    fetch = false;
                  };
                  titleConvo = true;
                  titleModel = "@cf/zai-org/glm-4.7-flash";
                  modelDisplayLabel = "Cloudflare Workers AI";
                }
              ];
            };

            mcpServers = {
              fetch = {
                command = "${pkgs.mcp-server-fetch}/bin/mcp-server-fetch";
                args = [ ];
              };

              nixos = {
                command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
                args = [ ];
              };
            }
            // lib.optionalAttrs (cfg.mcpFilesystemPaths != { }) {
              filesystem = {
                command = "${pkgs.mcp-server-filesystem}/bin/mcp-server-filesystem";
                args = map (name: "${mcpFilesystemContainerPath}/${name}") (
                  builtins.attrNames cfg.mcpFilesystemPaths
                );
              };
            }
            // cfg.mcpServers;
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
