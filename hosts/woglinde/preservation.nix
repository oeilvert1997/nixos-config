{
  config,
  inputs,
  lib,
  username,
  ...
}:
{
  imports = [
    inputs.preservation.nixosModules.default
  ];

  boot.initrd.systemd.enable = true;

  preservation = {
    enable = true;

    preserveAt."/persistent" = {
      directories = [
        "/etc/NetworkManager/system-connections"

        "/var/log"

        "/var/lib/nixos"
        "/var/lib/systemd"

        "/var/lib/bluetooth"
        "/var/lib/tailscale"

        "/var/lib/nixos-containers"
      ];

      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
        }
        {
          file = "/etc/ssh/ssh_host_ed25519_key";
          mode = "0600";
        }
        {
          file = "/etc/ssh/ssh_host_ed25519_key.pub";
        }
      ];

      users.${username} = {
        commonMountOptions = [
          "x-gvfs-hide"
        ];

        directories = [

          # XDG Directories
          "Desktop"
          "Documents"
          "Downloads"
          "Music"
          "Pictures"
          "Projects"
          "Public"
          "Templates"
          "Videos"

          ".cache"

          "nixos-config"

          ".local/state/home-manager"
          ".local/state/nix/profiles"
          ".local/share/nix"
          ".local/share/direnv"

          {
            directory = ".ssh";
            mode = "0700";
          }
          {
            directory = ".gnupg";
            mode = "0700";
          }
          {
            directory = ".config/sops";
            mode = "0700";
          }
          {
            directory = ".config/sops/age";
            mode = "0700";
          }

          # ".config/Bitwarden"
          # ".config/blender"
          ".config/Code"
          ".config/dconf"
          ".config/gh"
          ".config/mozc"
          ".config/mozilla"
          ".config/obsidian"
          # ".config/pulse"
          # ".config/Vencord"
        ];

        files = [
          {
            file = ".local/share/zsh/history";
          }
        ];
      };
    };
  };

  systemd = {
    services.systemd-machine-id-commit = {
      unitConfig.ConditionPathIsMountPoint = [
        ""
        "/persistent/etc/machine-id"
      ];
      serviceConfig.ExecStart = [
        ""
        "systemd-machine-id-setup --commit --root /persistent"
      ];
    };
    suppressedSystemUnits = [
      "systemd-machine-id-commit.service"
    ];
    tmpfiles.settings.preservation =
      let
        permission = {
          user = username;
          group = lib.mkForce config.users.users.${username}.group;
          mode = lib.mkForce "0750";
        };
      in
      {
        "/home/${username}/.config".z = permission;
        "/home/${username}/.local".z = permission;
        "/home/${username}/.local/share".z = permission;
        "/home/${username}/.local/state".z = permission;
      };
  };
}
