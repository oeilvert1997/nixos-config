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
      "/etc/ssh/ssh_host_ed25519_key"
    ];

    defaultSopsFormat = "yaml";

    defaultSopsFile = "${inputs.nixos-secrets}/common.yaml";

    validateSopsFiles = true;

    secrets = {
      "user/password_hash".neededForUsers = true;

      "user/ssh-auth-key" = {
        owner = "${username}";
        path = "/home/${username}/.ssh/id_ed25519";
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
