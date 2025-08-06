{
  config,
  ...
}:
{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    history = {
      path = "${config.xdg.dataHome}/zsh/history";
      size = 10000;
      ignoreAllDups = true;
      ignorePatterns = [
        "cd"
        "clear"
        "exit"
        "ls"
        "pwd"
      ];

    };

    # plugins = [
    #   {
    #     name = "powerlevel10k";
    #     src = pkgs.zsh-powerlevel10k;
    #   }
    # ];

    defaultKeymap = "emacs";

    initContent = ''
      # Load necessary functions for history search
      autoload -U up-line-or-beginning-search
      autoload -U down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search

      bindkey "$terminfo[kcuu1]" up-line-or-beginning-search
      bindkey "$terminfo[kcud1]" down-line-or-beginning-search
    '';
  };
}
