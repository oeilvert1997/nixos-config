{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.nixos.librechat;

  mcpFilesystemContainerPath = "/repos";
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

    mcpFilesystemHostPath = lib.mkOption {
      type = lib.types.path;
      description = "Host directory exposed to the filesystem MCP server.";
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

        "${mcpFilesystemContainerPath}" = {
          hostPath = cfg.mcpFilesystemHostPath;
          isReadOnly = true;
        };
      };

      config = { pkgs, ... }: {
        nixpkgs.config.allowUnfree = true;

        services.librechat = {
          enable = true;

          enableLocalDB = true;

          # Waiting for a bug fix
          # openFirewall = true;

          credentialsFile = "/run/secrets/librechat.env";

          env = {
            PORT = 3080;
            HOST = "0.0.0.0";
            ALLOW_REGISTRATION = cfg.allowRegistration;
            GOOGLE_KEY = "\${GOOGLE_KEY}";
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
                args = [
                  mcpFilesystemContainerPath
                ];
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

        networking = {
          firewall.allowedTCPPorts = [
            3080
          ];

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
