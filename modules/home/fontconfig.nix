{
  pkgs,
  ...
}:
{
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [
        "Noto Sans"
        "Noto Sans CJK JP"
        "Noto Color Emoji"
      ];
      serif = [
        "Noto Serif"
        "Noto Serif CJK JP"
        "Noto Color Emoji"
      ];
      monospace = [
        "Noto Sans Mono"
        "Noto Sans Mono CJK JP"
        "Noto Color Emoji"
      ];
      emoji = [
        "Noto Color Emoji"
      ];
    };
  };

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
  ];
}
