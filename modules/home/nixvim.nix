_: {
  programs.nixvim = {
    enable = true;

    viAlias = true;
    vimAlias = true;

    opts = {
      number = true;

      list = true;
      listchars = {
        tab = "» ";
        space = "·";
        extends = "»";
        precedes = "«";
      };

      cursorline = true;

      scrolloff = 8;
      sidescrolloff = 16;

      wrap = false;

      shiftwidth = 0;
      softtabstop = -1;
      tabstop = 4;

      autoindent = true;
      smartindent = true;

      expandtab = true;
      smarttab = true;

      clipboard = "unnamedplus";
    };

    keymaps = [
      {
        mode = "n";
        key = "<Esc><Esc>";
        action = "<cmd>nohlsearch<CR>";
        options.silent = true;
      }
    ];

    plugins = {
      lualine.enable = true;
    };

    highlight = {
      Normal = {
        bg = "NONE";
      };
      NormalFloat = {
        bg = "NONE";
      };
      CursorLineNr = {
        fg = "#ffffff";
        bg = "NONE";
      };
      CursorLine = {
        bg = "NONE";
      };
    };
  };
}
