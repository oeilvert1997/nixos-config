{
  inputs,
  self,
  ...
}:
let
  mkHomeConfiguration =
    {
      system,
      username,
      modules ? [ ],
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = { inherit inputs self username; };
      modules = [
        ../users/${username}/home.nix
        ../profiles/home/core.nix
      ]
      ++ modules;
    };
in
{
  flake.homeConfigurations = {
    "oeilvert@woglinde" = mkHomeConfiguration {
      system = "x86_64-linux";
      username = "oeilvert";
      modules = [
        ../profiles/home/desktop.nix
      ];
    };

    "oeilvert@diva-00" = mkHomeConfiguration {
      system = "x86_64-linux";
      username = "oeilvert";
      modules = [
        ../profiles/home/i3.nix
      ];
    };
  };
}
