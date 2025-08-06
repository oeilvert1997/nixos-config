_: {
  programs.niri = {
    enable = true;

    settings = {
      input.keyboard.xkb.layout = "us";

      binds = {
        "Mod+Shift+Slash".action.show-hotkey-overlay = { };
        "Mod+Return".action.spawn = [ "kitty" ];
        "Mod+D".action.spawn = [
          "wofi"
          "--show"
          "drun"
        ];
        "Mod+R".action.spawn = [
          "wofi"
          "--show"
          "run"
        ];
        "Mod+Space".action.spawn = [
          "fcitx5-remote"
          "-t"
        ];
        "Mod+Q".action.close-window = { };
        "Mod+Shift+E".action.quit = { };
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+H".action.focus-column-left = { };
        "Mod+L".action.focus-column-right = { };
      };

      layout = {
        border = {
          enable = true;
          width = 0;
          active.color = "#1e1e2ecc";
          inactive.color = "#1e1e2ecc";
        };
        focus-ring = {
          enable = true;
          width = 2;
          active = {
            color = "#89b4fa";
          };
        };
      };

      window-rules = [
        {
          geometry-corner-radius = {
            bottom-left = 12.0;
            bottom-right = 12.0;
            top-left = 12.0;
            top-right = 12.0;
          };
          clip-to-geometry = true;

          draw-border-with-background = true;
        }
      ];

      prefer-no-csd = true;
    };
  };
}
