{
  pkgs,
  ...
}:
let
  defaultSettings = {
    "update.mode" = "none";
    "update.showReleaseNotes" = false;

    "editor.minimap.enabled" = false;

    "workbench.startupEditor" = "none";

    "extensions.autoUpdate" = false;
    "extensions.autoCheckUpdates" = false;

    "extensions.experimental.affinity" = {
      "asvetliakov.vscode-neovim" = 1;
    };

    "vscode-neovim.neovimClean" = true;
  };

  defaultExtensions = with pkgs.vscode-extensions; [
    asvetliakov.vscode-neovim
    github.codespaces
    mkhl.direnv
  ];
in
{
  programs.vscode = {
    enable = true;

    mutableExtensionsDir = false;

    profiles = {
      default = {
        enableExtensionUpdateCheck = false;

        userSettings = defaultSettings;

        extensions = defaultExtensions;
      };

      python = {
        userSettings = defaultSettings // {
        };

        extensions =
          defaultExtensions
          ++ (with pkgs.vscode-extensions; [
            ms-python.python
            ms-python.vscode-pylance
            ms-python.debugpy
            ms-toolsai.jupyter
            ms-toolsai.jupyter-keymap
            ms-toolsai.jupyter-renderers
            ms-toolsai.vscode-jupyter-slideshow
            ms-toolsai.vscode-jupyter-cell-tags
          ]);
      };
    };
  };
}
