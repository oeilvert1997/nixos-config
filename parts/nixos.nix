{
  inputs,
  self,
  ...
}:
let
  mkNixosConfiguration =
    {
      hostname,
      system,
      username ? "oeilvert",
      modules ? [ ],
    }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit
          inputs
          self
          hostname
          username
          ;
      };
      modules = [
        ../hosts/${hostname}
        ../profiles/nixos/core.nix
        {
          nixpkgs.overlays = [ self.overlays.default ];
        }
      ]
      ++ modules;
    };
in
{
  flake.nixosConfigurations = {
    woglinde = mkNixosConfiguration {
      hostname = "woglinde";
      system = "x86_64-linux";
      modules = [
        ../profiles/nixos/desktop.nix
      ];
    };

    rhein = mkNixosConfiguration {
      hostname = "rhein";
      system = "aarch64-linux";
      modules = [
        ../profiles/nixos/server.nix
      ];
    };
  };

  flake.checks = {
    x86_64-linux.woglinde-toplevel = self.nixosConfigurations.woglinde.config.system.build.toplevel;

    aarch64-linux.rhein-toplevel = self.nixosConfigurations.rhein.config.system.build.toplevel;
  };
}
