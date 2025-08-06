{
  pkgs,
  self,
  ...
}:
let
  wallpaperPath = "${self}/assets/wallpapers/Gekkou_3840x2160.png";
in
{
  wayland.windowManager.hyprland = {
    enable = true;

    xwayland.enable = true;

    systemd.enable = true;

    settings = {

      # Monitors
      monitor = [
        ",preferred,auto,auto"
      ];

      # Input
      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;

        sensitivity = 0;

        touchpad = {
          natural_scroll = false;
        };
      };

      # Autostart
      exec-once = [
        "waybar"
        "mako"
        "fcitx5 -d"
      ];

      # Environment variables
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR,24"
        "INPUT_METHOD,fcitx5"
        "XMODIFIERS,@im=fcitx5"
        "QT_IM_MODULE,fcitx5"
        "SDL_IM_MODULE,fcitx5"
      ];

      # Look and feel
      general = {
        gaps_in = 4;
        gaps_out = 16;
        border_size = 2;

        # ff=100%, cc=80%, aa=67%, 80=50%, 40=25%
        # "col.active_border" = "rgba(3F4A59ff)";
        # "col.inactive_border" = "rgba(3F4A5940)";

        resize_on_border = false;

        allow_tearing = false;

        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
        };

        blur = {
          enabled = true;
          size = 15;
          passes = 3;
          xray = false;
          noise = 0.08;
          contrast = 1.5;
          brightness = 0.5;
        };
      };

      animations = {
        enabled = true;

        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
        ];

        animation = [
          "windows, 1, 7, myBezier"
          "windowsIn, 1, 7, myBezier, slide"
          "windowsOut, 1, 7, myBezier, slide"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, myBezier, slide"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      # Keybindings
      "$mod" = "SUPER";

      bind = [
        "$mod SHIFT, E, exit"
        "$mod, Return, exec, kitty"
        "$mod, Q, killactive"
        "$mod, V, togglefloating"
        # "$mod, J, togglesplit" # dwindle
        # "$mod, P, pseudo" # dwindle
        "$mod, D, exec, wofi --show drun"
        "$mod, R, exec, wofi --show run"

        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"

        "$mod SHIFT, H, workspace, e-1"
        "$mod SHIFT, L, workspace, e+1"

        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"

        "$mod, bracketleft, exec, pamixer -d 5"
        "$mod, bracketright, exec, pamixer -i 5"

        "$mod SHIFT, bracketleft, exec, ddcutil setvcp 10 - 5"
        "$mod SHIFT, bracketright, exec, ddcutil setvcp 10 + 5"

        "$mod, mouse_down, workspace, e-1"
        "$mod, mouse_up, workspace, e+1"
      ]
      ++ (builtins.concatLists (
        builtins.genList (
          i:
          let
            ws = i + 1;
          in
          [
            "$mod, code:1${toString i}, workspace, ${toString ws}"
            "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        ) 9
      ));

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      workspace = builtins.genList (i: "${toString (i + 1)}, persistent:true") 5;

      windowrule = [
        "suppressevent maximize, class:.*"
        # Fix some dragging issues with XWayland
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];

      windowrulev2 = [
        "opacity 0.9 0.9, class:^(kitty)$"
        "opacity 0.9 0.9, class:^(Alacritty)$"
      ];
    };
  };

  home.sessionVariables.NIXOS_OZONE_WL = "1";

  home.packages = with pkgs; [
    # hyprpaper
    hyprpicker
    hyprsysteminfo
    hyprland-qt-support
    wl-clipboard

    grim
    slurp
  ];

  programs.satty = {
    enable = true;
    settings = {
      general = {
        copy-command = "wl-copy";
      };
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };
  };

  # xdg.userDirs.createDirectories = true;
  # home.file."Pictures/wallpapers/nixos.png".source = ./assets/wallpaper

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "${wallpaperPath}"
      ];
      wallpaper = [
        ",${wallpaperPath}"
      ];
    };
  };
  # services.hypridle.enable = true;
  # services.hyprsunset.enable = true;
  # services.hyprpolkitagent.enable = true;
  # services.cliphist.enable = true;

  # programs.hyprlock.enable = true;
  # programs.ranger.enable = true;
}
