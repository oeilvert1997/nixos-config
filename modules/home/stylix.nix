{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.home.stylix;
in
{
  options.modules.home.stylix = {
    enable = lib.mkEnableOption "stylix";

    image = lib.mkOption {
      type = lib.types.nullOr lib.types.path;

      default = null;

      description = "wallpaper image path";
    };

    settings = lib.mkOption {
      type =
        with lib.types;
        let
          valueType =
            nullOr (oneOf [
              bool
              int
              float
              str
              path
              (attrsOf valueType)
              (listOf valueType)
            ])
            // {
              description = "stylix configuration value";
            };
        in
        valueType;

      default = { };

      description = "additional stylix settings to merge";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        stylix = {
          enable = true;

          image = lib.mkIf (cfg.image != null) cfg.image;

          # base16Scheme = customScheme;
          base16Scheme = {
            inherit (config.colorScheme)
              slug
              name
              author
              palette
              ;
          };

          polarity = "dark";

          fonts.sizes = {
            terminal = 11;
          };

          # fonts = {
          #   serif = {
          #     package = pkgs.noto-fonts;
          #     name = "Noto Serif";
          #   };

          #   sansSerif = {
          #     package = pkgs.noto-fonts;
          #     name = "Noto Sans";
          #   };

          #   monospace = {
          #     package = pkgs.nerd-fonts.jetbrains-mono;
          #     name = "JetBrainsMono Nerd Font";
          #   };

          #   emoji = {
          #     package = pkgs.noto-fonts-color-emoji;
          #     name = "Noto Color Emoji";
          #   };
          # };

          targets.vscode.profileNames = [
            "default"
            "python"
          ];

          # targets.nixvim.pluginConfigs."mini.base16".highlightOverride = {
          #   Identifier = { fg = "#${config.lib.stylix.colors.base05}"; };
          # };
        };
      }
      {
        stylix = cfg.settings;
      }
    ]
  );
}
