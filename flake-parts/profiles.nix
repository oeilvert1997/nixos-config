{
  inputs,
  ...
}:
{
  flake.lib = {
    mkProfile = name: modules: {
      imports = modules;
      networking.hostName = inputs.nixpkgs.lib.mkDefault name;
    };

    withCore =
      modules:
      [
        ../modules/nixos/core.nix
      ]
      ++ modules;

    # withDevelopment = modules: [
    #   ../modules/nixos/development.nix
    # ] ++ modules;

    # withGui = modules: [
    #   ../modules/nixos/gui.nix
    # ] ++ modules;
  };

  # flake.templates = {
  #   host = {
  #     path = ./templates/host;
  #     description = "New host configuration template";
  #   };
  #
  #   user = {
  #     path = ./templates/user;
  #     description = "New user configuration template";
  #   };
  # };
}
