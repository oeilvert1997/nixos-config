_: {
  programs.nixvim = {
    enable = true;

    viAlias = true;
    vimAlias = true;

    colorschemes = {
      catppuccin = {
        enable = true;
        settings = {
          flavour = "mocha";
          transparent_background = true;
        };
      };
      everforest = {
        enable = false;
        settings = {
          transparent_background = 2;
        };
      };
    };

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

    extraConfigLua = ''
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffffff", bg = "NONE" })
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "NONE" })
    '';
  };
}
