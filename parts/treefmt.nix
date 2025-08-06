{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem = { config, pkgs, ... }: {
    treefmt = {
      projectRootFile = "flake.nix";

      programs = {
        deadnix = {
          enable = true;
        };

        nixfmt = {
          enable = true;
          package = pkgs.nixfmt-rfc-style;
        };

        prettier = {
          enable = true;
        };

        shellcheck = {
          enable = true;
        };

        shfmt = {
          enable = true;
          indent_size = 2;
        };

        statix = {
          enable = true;
        };
      };

      settings = {
        global = {
          excludes = [
            "*.lock"
          ];
        };

        formatter = {
          deadnix = {
            includes = [ "*.nix" ];
            priority = 1;
          };

          nixfmt = {
            includes = [ "*.nix" ];
            options = [ "--width=100" ];
          };

          prettier = {
            includes = [ "*.json" "*.yaml" "*.yml" "*.md" ];
          };

          shellcheck = {
            includes = [ "*.sh" "*.bash" ];
          };

          shfmt = {
            includes = [ "*.sh" "*.bash" ];
          };

          statix = {
            includes = [ "*.nix" ];
            priority = 0;
          };
        };
      };
    };

    formatter = config.treefmt.build.wrapper;
  };
}
