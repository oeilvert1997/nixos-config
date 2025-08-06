{
  pkgs,
  ...
}:
{
  programs.vscode = {
    enable = true;

    mutableExtensionsDir = false;

    profiles.default = {
      enableExtensionUpdateCheck = false;

      userSettings = {
        "update.mode" = "none";
        "update.showReleaseNotes" = false;

        "extensions.autoUpdate" = false;
        "extensions.autoCheckUpdates" = false;

        "extensions.experimental.affinity" = {
          "asvetliakov.vscode-neovim" = 1;
        };

        "vscode-neovim.neovimClean" = true;
      };

      extensions = with pkgs.vscode-extensions; [
        asvetliakov.vscode-neovim
        github.codespaces
      ];
    };
  };
}
