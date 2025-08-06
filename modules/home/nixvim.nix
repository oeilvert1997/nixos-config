_: {
  programs.nixvim = { enable = true;

    viAlias = true;
    vimAlias = true;

    opts = {
      number = true;
      numberwidth = 5;

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
      smarttab = true; clipboard = "unnamedplus";
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

      snacks = {
        enable = true;
        settings = {
          indent = {
            indent.enabled = false;
            scope.enabled = true;
            scope.char = "▏";
            animate.enabled = true;
          };
        };
      };

      # indent-blankline = {
      #   enable = true;
      #   settings = {
      #     scope = {
      #       enabled = true;
      #       show_start = false;
      #       show_end = false;
      #       show_exact_scope = true;
      #     };
      #   };
      #   luaConfig.pre = ''
      #     vim.api.nvim_set_hl(0, "IblIndent", { fg = "#ff0000" })
      #     vim.api.nvim_set_hl(0, "IblScope", { fg = "#00ff00" })
      #     vim.api.nvim_set_hl(0, "IblWhitespace", { fg = "#0000ff" })
      #   '';
      # };

      # treesitter = {
      #   enable = false;
      #   settings = {
      #     highlight.enable = true;
      #     indent.enable = true;
      #   };
      # };

      cmp = { enable = true;
        settings = {
          snippet = {
            expand = ''
              function(args)
                require('luasnip').lsp_expand(args.body)
              end
            '';
          };
          mapping = {
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping.select_next_item()";
            "<S-Tab>" = "cmp.mapping.select_prev_item()";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
        };
      };

      cmp-nvim-lsp.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp_luasnip.enable = true;

      luasnip.enable = true;

      lsp = {
        enable = true;
        servers.nil_ls.enable = true;
      };

    };

    extraConfigLua = ''
      vim.api.nvim_set_hl(0, "LineNr", { link = "Comment", bg = "NONE" })
      vim.api.nvim_set_hl(0, "LineNrAbove", { link = "Comment", bg = "NONE" })
      vim.api.nvim_set_hl(0, "LineNrBelow", { link = "Comment", bg = "NONE" })
      vim.api.nvim_set_hl(0, "CursorLineNr", { link = "Normal", bg = "NONE" })
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "SnacksIndentScope", { link = "Comment", bg = "NONE" })
    '';
  };
}
