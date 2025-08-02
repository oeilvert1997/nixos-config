{
  inputs,
  ...
}:
{
  flake.overlays = {
    default = _final: _prev: {
      # myCustomPackage = final.callPackage ../packages/my-custom-package { };
    };

    development = _final: _prev: {
    };
  };

  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.self.overlays.default
        ];
        config = {
          allowUnfree = true;
        };
      };
    };
}
