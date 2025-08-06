_: {
  programs.nixvim = {
    enable = true;

    colorschemes.kanagawa-paper = {
      enable = false;
      settings = {
        transparent = true;
      };
    };

    viAlias = true;
    vimAlias = true;

    opts = {
      number = true;
      numberwidth = 4;
      signcolumn = "yes";
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
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>lua vim.diagnostic.open_float()<CR>";
        options.silent = true;
      }
    ];

    diagnostic = {
      settings = {
        virtual_text = false;
        signs = true;
        underline = true;
        update_in_insert = false;
        severity_sort = true;

        float = {
          border = "rounded";
          source = "if_many";
          header = "";
          prefix = "";
        };
      };
    };

    highlightOverride = {
      LineNr = {
        link = "Comment";
        bg = "NONE";
      };

      LineNrAbove = {
        link = "Comment";
        bg = "NONE";
      };

      LineNrBelow = {
        link = "Comment";
        bg = "NONE";
      };

      CursorLine = {
        bg = "NONE";
      };

      CursorLineNr = {
        link = "Normal";
        bg = "NONE";
      };

      SignColumn = {
        bg = "NONE";
      };

      CursorLineSign = {
        bg = "NONE";
      };

      DiagnosticSignError = {
        link = "DiagnosticError";
        bg = "NONE";
      };

      DiagnosticSignWarn = {
        link = "DiagnosticWarn";
        bg = "NONE";
      };

      DiagnosticSignInfo = {
        link = "DiagnosticInfo";
        bg = "NONE";
      };

      DiagnosticSignHint = {
        link = "DiagnosticHint";
        bg = "NONE";
      };

      DiagnosticSignOk = {
        link = "DiagnosticOk";
        bg = "NONE";
      };

      NormalFloat = {
        bg = "NONE";
      };

      DiagnosticFloatingError = {
        link = "DiagnosticError";
        bg = "NONE";
      };

      DiagnosticFloatingWarn = {
        link = "DiagnosticWarn";
        bg = "NONE";
      };

      DiagnosticFloatingInfo = {
        link = "DiagnosticInfo";
        bg = "NONE";
      };

      DiagnosticFloatingHint = {
        link = "DiagnosticHint";
        bg = "NONE";
      };

      DiagnosticFloatingOk = {
        link = "DiagnosticOk";
        bg = "NONE";
      };
    };

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

      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };

      cmp = {
        enable = true;
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
        servers = {
          nixd = {
            enable = true;
            settings = {
              formatting.command = [ "nixfmt" ];
              nixpkgs.expr = "import <nixpkgs> {}";
            };
          };
        };
      };
    };

    extraConfigLua = ''
      vim.api.nvim_set_hl(0, "SnacksIndentScope", { link = "Comment", bg = "NONE" })
    '';
  };
}
