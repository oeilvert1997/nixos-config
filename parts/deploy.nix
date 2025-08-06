{
  inputs,
  self,
  ...
}:
{
  flake.deploy.nodes.rhein = {
    hostname = "rhein";
    sshUser = "oeilvert";
    sshOpts = [
      "-o"
      "StrictHostKeyChecking=accept-new"
    ];
    fastConnection = true;

    remoteBuild = true;

    profiles.system = {
      user = "root";
      sudo = "sudo -H";
      path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.rhein;
    };
  };

  flake.checks = builtins.mapAttrs (
    _system: deployLib: deployLib.deployChecks self.deploy
  ) inputs.deploy-rs.lib;
}
