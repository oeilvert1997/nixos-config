_: {
  programs.waybar = {
    enable = true;
    systemd.enable = false;

    settings = {
      primary = {
        layer = "top";
        output = [
          "*"
        ];
        margin-top = 8;
        position = "top";
        modules-left = [ "clock" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ "clock" ];

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          persistent-only = true;
          format-icons = {
            "1" = "󰽤";
            /* nf-md-moon-new */ "2" = "󰽤";
            "3" = "󰽤";
            "4" = "󰽤";
            "5" = "󰽤";
            "active" = "󰽢";
            "default" = "󰽤";
          };
          sort-by-number = true;
        };
        clock = {
          interval = 60;
          format = "󰥔 {:%H:%M}";
        };
      };
    };

    style = ''
      * {
        border: none;
        font-family: "JetBrainsMono Nerd Font Propo";
        font-size: 16px;
        font-weight: bold;
      }

      window#waybar {
        background: transparent;
      }

      .modules-left,
      .modules-center,
      .modules-right {
        margin: 0px 20px;
      }

      #clock,
      #workspaces {
        padding: 0px 14px;
        border-radius: 16px;
        background-color: #1e1e2e;
      }

      #workspaces {
      }

      #workspaces button {
      }

      #workspaces button.active {
      }

      #workspaces button:hover {
      }
    '';
  };
}
