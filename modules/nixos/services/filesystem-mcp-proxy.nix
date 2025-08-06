{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.nixos.filesystemMcpProxy;
in
{
  options.modules.nixos.filesystemMcpProxy = {
    enable = lib.mkEnableOption "filesystem MCP server exposed over SSE via mcp-proxy";

    paths = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      description = "Directories exposed by the filesystem MCP server.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8765;
      description = "Port to listen on for SSE.";
    };

    isReadOnly = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to expose the target directory as read-only.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      description = "User the service runs as.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "users";
      description = "Group the service runs as.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.filesystem-mcp-proxy = {
      description = "stdio to SSE proxy for filesystem MCP server.";
      wantedBy = [
        "multi-user.target"
      ];
      after = [
        "network-online.target"
        "tailscaled.service"
      ];
      wants = [
        "network-online.target"
      ];

      unitConfig.RequiresMountFor = cfg.paths;

      serviceConfig = {
        ExecStart = ''
          ${pkgs.mcp-proxy}/bin/mcp-proxy \
          --host=0.0.0.0 \
          --port=${toString cfg.port} \
          ${pkgs.mcp-server-filesystem}/bin/mcp-server-filesystem ${lib.escapeShellArgs cfg.paths}
        '';
        Restart = "on-failure";

        User = cfg.user;
        Group = cfg.group;

        ProtectSystem = "strict";
        ReadOnlyPaths = lib.optional cfg.isReadOnly cfg.paths;
        ReadWritePaths = lib.optional (!cfg.isReadOnly) cfg.paths;
      };
    };

    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [
      cfg.port
    ];
  };
}
