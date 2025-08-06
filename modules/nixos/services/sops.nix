{
  config,
  inputs,
  username,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    age.sshKeyPaths = [
      (
        if (config.preservation.enable or false) then
          "/persistent/etc/ssh/ssh_host_ed25519_key"
        else
          "/etc/ssh/ssh_host_ed25519_key"
      )
    ];

    defaultSopsFormat = "yaml";

    defaultSopsFile = "${inputs.nixos-secrets}/common.yaml";

    validateSopsFiles = true;

    secrets = {
      "user/password_hash".neededForUsers = true;

      "user/auth-ssh-key" = {
        owner = "${username}";
        mode = "0400";
      };

      "user/github-ssh-key" = {
        owner = "${username}";
        mode = "0400";
      };

      # "tailscale/authkey" = { };

      "librechat/jwt-secret" = { };
      "librechat/jwt-refresh-secret" = { };
      "librechat/creds-key" = { };
      "librechat/creds-iv" = { };

      "api-keys/gemini" = { };
      # "api-keys/openai" = { };
      # "api-keys/claude" = { };

      "syncthing/gui-password" = {
        owner = "${username}";
        mode = "0400";
      };
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
        GOOGLE_KEY=${config.sops.placeholder."api-keys/gemini"}
      '';
    };
  };
}
