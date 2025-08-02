{
  inputs,
  ...
}:
{
  flake.homeConfigurations =
    let
      mkHome =
        username: hostname: system: profile:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          extraSpecialArgs = {
            inherit
              inputs
              username
              hostname
              profile
              ;
          };
          modules = [
            ../profiles/home/${profile}.nix
            ../users/${username}/home.nix
            ../modules/home-manager/dotfiles.nix
          ];
        };
    in
    {
      "oeilvert@diva-00" = mkHome "oeilvert" "diva-00" "x86_64-linux" "server-test";
    };
}
