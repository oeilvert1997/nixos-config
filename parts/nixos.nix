{ inputs, self, ... }:
let
  mkNixosConfiguration = { hostname, system, username, modules ? [] }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs self hostname username; };
      modules = [
        inputs.sops-nix.nixosModules.sops
        ../hosts/${hostname}
        ../profiles/nixos/core.nix
        {
          nixpkgs.overlays = [ self.overlays.default ];
        }
      ] ++ modules;
    };
in
{
  flake.nixosConfigurations = {
    flosshilde = mkNixosConfiguration {
      hostname = "flosshilde";
      system = "x86_64-linux";
      username = "oeilvert";
      modules = [
      ];
    };

    diva-00 = mkNixosConfiguration {
      hostname = "diva-00";
      system = "x86_64-linux";
      username = "oeilvert";
      modules = [
      ];
    };
  };
}
