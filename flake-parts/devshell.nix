_: {
  perSystem =
    { pkgs, ... }:
    {
      devshells.default = {
        name = "default";

        commands = [
          {
            name = "rebuild";
            help = "Rebuild NixOS system";
            command = "sudo nixos-rebuild switch --flake .#$1";
          }
          {
            name = "fmt";
            help = "Format nix files (treefmt-nix)";
            command = "nix fmt";
          }
        ];

        packages = with pkgs; [
          deadnix
          git
          home-manager
          nixos-rebuild
          statix
        ];

        env = [
          {
            name = "FLAKE_ROOT";
            eval = "$PRJ_ROOT";
          }
        ];

        motd = ''
          {202}Welcome to NixOS configuration development environment{reset}
          $(type -p menu &>/dev/null && menu)
        '';
      };
    };
}
