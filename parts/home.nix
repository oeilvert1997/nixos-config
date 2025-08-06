{ inputs, self, ... }:
let
  mkHomeConfiguration = { system, username, hostname, modules ? [] }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = { inherit inputs self hostname; };
      modules = [
        ../profiles/home/core.nix
        ../users/${username}/home.nix
        ../users/${username}/${hostname}.nix
      ] ++ modules;
    };
in
{
  flake.homeConfigurations = {
    "oeilvert@flosshilde" = mkHomeConfiguration {
      system = "x86_64-linux";
      username = "oeilvert";
      hostname = "flosshilde";
      modules = [
      ];
    };

    "oeilvert@diva-00" = mkHomeConfiguration {
      system = "x86_64-linux";
      username = "oeilvert";
      hostname = "diva-00";
      modules = [
      ];
    };
  };
}
