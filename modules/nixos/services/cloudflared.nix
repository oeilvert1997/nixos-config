{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.nixos.cloudflared;
in
{
  options.modules.nixos.cloudflared = {
    enable = lib.mkEnableOption "cloudflared tunnel";

    tunnelId = lib.mkOption {
      type = lib.types.str;
      description = "Cloudflare Tunnel ID (UUID)";
    };

    credentialsSecret = lib.mkOption {
      type = lib.types.str;
      default = "cloudflared/librechat/credentials";
      description = "Name of the sops secret containing the tunnel credentials JSON.";
    };

    ingress = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
      description = "Hostname to origin service URL mapping.";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets.${cfg.credentialsSecret} = {
      restartUnits = [
        "cloudflared-tunnel-${cfg.tunnelId}.service"
      ];
    };

    services.cloudflared = {
      enable = true;

      tunnels.${cfg.tunnelId} = {
        credentialsFile = config.sops.secrets.${cfg.credentialsSecret}.path;
        default = "http_status:404";
        inherit (cfg) ingress;
      };
    };
  };
}
