_: {
  programs.ssh = {
    enable = true;

    enableDefaultConfig = false;

    settings = {
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "yes";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };

      "github.com" = {
        IdentityFile = "~/.ssh/id_ed25519_github";
        IdentitiesOnly = true;
      };
    };
  };

  home.file = {
    ".ssh/id_ed25519.pub".text = ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIU5ZpZcRU3EwBtvNKifj2mSSfhk8KIJQIHIkSX1mqCb
    '';

    ".ssh/id_ed25519_github.pub".text = ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAQ3S6ZS+jNdoXpLZ7isu/1+T6T+R75NUgWeJCaPWuqZ
    '';
  };
}
