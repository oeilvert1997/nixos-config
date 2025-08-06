{
  config,
  inputs,
  username,
  ...
}:
let
  userReadable = {
    owner = "${username}";
    mode = "0400";
  };
in
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

      "user/auth-ssh-key" = userReadable;

      "user/github-ssh-key" = userReadable;

      # "tailscale/authkey" = { };

      "syncthing/gui-password" = userReadable;
    };
  };
}
