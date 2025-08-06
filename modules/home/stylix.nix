{
  config,
  lib,
  self,
  ...
}:
let
  cfg = config.modules.home.stylix;
  baseScheme = {
    scheme = "baseScheme";
    author = "oeilvert";
    base00 = "#222436"; # Background
    base01 = "#1e2030"; # Lighter background
    base02 = "#2f334d"; # Selection background
    base03 = "#444a73"; # Comments, invisibles
    base04 = "#828bb8"; # Dark foreground
    base05 = "#c8d3f5"; # Default foreground
    base06 = "#b4c2f0"; # Light foreground
    base07 = "#c8d3f5"; # Lightest foreground
    base08 = "#c099ff"; # Variables, XML tags
    base09 = "#ffc777"; # Integers, booleans
    base0A = "#ffc777"; # Classes, search text bg
    base0B = "#c3e88d"; # Strings
    base0C = "#86e1fc"; # Regex, escape chars
    base0D = "#82aaff"; # Functions, methods
    base0E = "#fca7ea"; # Keywords, storage
    base0F = "#c53b53"; # Deprecated, special
    base10 = "#1e2030"; # Darker background
    base11 = "#1a1b2a"; # Darkest background
    base12 = "#ff757f"; # Bright red
    base13 = "#ffd793"; # Bright orange/yellow
    base14 = "#c3e88d"; # Bright green
    base15 = "#86e1fc"; # Brightyan
    base16 = "#82aaff"; # Bright blue
    base17 = "#fca7ea"; # Bright magenta
  };

  customScheme = baseScheme // {
    base00 = "#24283b"; # Background
    base01 = "#1f2335"; # Lighter background
    base02 = "#292e42"; # Selection background
    base03 = "#414868"; # Comments, invisibles
    base04 = "#8089b3"; # Dark foreground
    base05 = "#a9b1d6"; # Default foreground
    base06 = "#c0caf5"; # Light foreground
    base07 = "#ffffff"; # Lightest foreground
    base08 = "#f7768e"; # Variables, XML tags
    base09 = "#ff9e64"; # Integers, booleans
    base0A = "#e0af68"; # Classes, search text bg
    base0B = "#9ece6a"; # Strings
    base0C = "#7dcfff"; # Regex, escape chars
    base0D = "#7aa2f7"; # Functions, methods
    base0E = "#bb9af7"; # Keywords, storage
    base0F = "#2ac3de"; # Deprecated, special
    base10 = "#1e2030"; # Darker background
    base11 = "#1a1b2a"; # Darkest background
    base12 = "#ff757f"; # Bright red
    base13 = "#ffd793"; # Bright orange/yellow
    base14 = "#c3e88d"; # Bright green
    base15 = "#86e1fc"; # Brightyan
    base16 = "#82aaff"; # Bright blue
    base17 = "#fca7ea"; # Bright magenta
  };
in
{
  options.modules.home.stylix = {
    enable = lib.mkEnableOption "stylix";

    image = lib.mkOption {
      type = lib.types.path;

      default = self + /assets/wallpapers/nixos.png;

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

          inherit (cfg) image;

          base16Scheme = customScheme;

          polarity = "dark";

          fonts.sizes = {
            terminal = 11;
          };

          targets.nixvim.pluginConfigs."mini.base16".highlightOverride = {
            Identifier = { fg = "#${config.lib.stylix.colors.base05}"; };
          };
        };
      }
      {
        stylix = cfg.settings;
      }
    ]
  );
}
