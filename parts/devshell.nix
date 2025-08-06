_: {
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          age
          cloudflared
          deadnix
          git
          hostname
          just
          nix-melt
          nix-output-monitor
          nix-tree
          nixos-anywhere
          openssl
          repomix
          sops
          ssh-to-age
          statix
          tree
        ];

        shellHook = ''
          echo ""
          echo "Welcome to NixOS Configuration Development Shell"
          echo "================================================"
          echo "Type 'just' to see all available commands."
          echo ""
        '';
      };
    };
}
