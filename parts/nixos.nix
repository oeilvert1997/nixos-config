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
      modules ? [ ],
    }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit
          inputs
          self
          hostname
          ;
      };
      modules = [
        inputs.sops-nix.nixosModules.sops
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

    flosshilde = mkNixosConfiguration {
      hostname = "flosshilde";
      system = "x86_64-linux";
      modules = [
        ../profiles/nixos/desktop.nix
      ];
    };

    diva-00 = mkNixosConfiguration {
      hostname = "diva-00";
      system = "x86_64-linux";
      modules = [
        ../profiles/nixos/vm.nix
        ../profiles/nixos/i3.nix
      ];
    };
  };
}
