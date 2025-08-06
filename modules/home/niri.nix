_: {
  programs.niri = {
    enable = true;

    settings = {
      input = {
        keyboard.xkb.layout = "us";
        focus-follows-mouse.enable = true;
      };

      binds = {
        "Mod+Shift+Slash".action.show-hotkey-overlay = { };
        "Mod+Return".action.spawn = [ "kitty" ];
        "Mod+D".action.spawn = [
          "wofi"
          "--show"
          "drun"
        ]; "Mod+Shift+D".action.spawn = [
          "wofi"
          "--show"
          "run"
        ];
        "Mod+Space".action.spawn = [
          "fcitx5-remote"
          "-t"
        ];
        "Mod+Q" = {
          repeat = false;
          action.close-window = { };
        };
        "Mod+Shift+E".action.quit = { };
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+H".action.focus-column-left = { };
        "Mod+L".action.focus-column-right = { };
        "Mod+J".action.focus-window-down = { };
        "Mod+K".action.focus-window-up = { };
        "Mod+Ctrl+H".action.move-column-left = { };
        "Mod+Ctrl+J".action.move-window-down = { };
        "Mod+Ctrl+K".action.move-window-up = { };
        "Mod+Ctrl+L".action.move-column-right = { };
        "Mod+U".action.focus-workspace-down = { };
        "Mod+I".action.focus-workspace-up = { };
        "Mod+Ctrl+U".action.move-column-to-workspace-down = { };
        "Mod+Ctrl+I".action.move-column-to-workspace-up = { };
        "Mod+Shift+U".action.move-workspace-down = { };
        "Mod+Shift+I".action.move-workspace-up = { };
        "Mod+R".action.switch-preset-column-width = { };
        "Mod+F".action.maximize-column = { };
        "Mod+Shift+F".action.fullscreen-window = { };
        "Mod+BracketLeft".action.consume-or-expel-window-left = { };
        "Mod+BracketRight".action.consume-or-expel-window-right = { };
        "Mod+V".action.toggle-window-floating = { };
        "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = { };
        "Mod+O" = {
          repeat = false;
          action.toggle-overview = { };
        };
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
