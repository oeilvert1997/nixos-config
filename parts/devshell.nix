{ inputs, ... }:
{
  imports = [
    inputs.devshell.flakeModule
  ];

  perSystem = { pkgs, ... }:
    {
      devshells.default = {
        packages = with pkgs; [
          inputs.home-manager.packages.${stdenv.hostPlatform.system}.home-manager
          deadnix
          git
          hostname
          statix
          tree
        ];

        env = [
        ];

        commands = [
          {
            name = "rebuild";
            category = "system";
            help = "Rebuild NixOS system";
            command = "sudo nixos-rebuild switch --flake .#\${1:-$(hostname)} --show-trace --verbose";
          }
          {
            name = "rebuild-home";
            category = "system";
            help = "Rebuild Home Manager configuration";
            command = "home-manager switch --flake .#\${1:-$(whoami)@$(hostname)} --show-trace --verbose";
          }
          {
            name = "gc";
            category = "maintenance";
            help = "Run garbage collection";
            command = "sudo nix-collect-garbage -d";
          }
          {
            name = "history";
            category = "maintenance";
            help = "Show system generation history";
            command = "sudo nixos-rebuild list-generations";
          }
          {
            name = "rollback";
            category = "maintenance";
            help = "Rollback to previous generation";
            command = "sudo nixos-rebuild switch --rollback";
          }
          {
            name = "update";
            category = "maintenance";
            help = "Update flake inputs";
            command = "nix flake update";
          }
          {
            name = "check";
            category = "formatting";
            help = "Run all checks (deadnix, statix)";
            command = ''
              echo "Running deadnix..."
              deadnix .
              echo "Running statix..."
              statix check
            '';
          }
          {
            name = "fmt";
            category = "formatting";
            help = "Format nix files";
            command = "nix fmt";
          }
        ];

        motd = ''

          󱁤 Welcome to NixOS Configuration Development Shell
          ==================================================

          Type 'menu' to see all available commands.
        '';
      };
    };
}
