_: {
  perSystem =
    { pkgs, ... }:
    {
      treefmt = {
        projectRootFile = "flake.nix";

        programs = {
          # Nix formatter
          nixfmt = {
            enable = true;
            package = pkgs.nixfmt-rfc-style;
          };

          # Scan unused code
          deadnix = {
            enable = true;
            # no-lamda-arg = true;
            # no-lamda-pattern-names = true;
          };

          # Nix linter
          statix = {
            enable = true;
            # format = "stderr";
          };
        };

        settings = {
          global = {
            excludes = [
              "*lock"
            ];
          };

          formatter = {
            nixfmt = {
              options = [ "--width=100" ];
              includes = [ "*.nix" ];
            };

            deadnix = {
              includes = [ "*.nix" ];
            };

            statix = {
              includes = [ "*.nix" ];
            };
          };
        };
      };
    };
}
