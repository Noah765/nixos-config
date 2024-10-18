{
  hm.programs.nixvim.plugins.lsp = {
    enable = true;
    # TODO Do we have to modify the capabilities table using lsp.capabilities?
    servers = {
      nixd.enable = true;
      dartls = {
        enable = true;
        settings.lineLength = 200;
      };
    };
    # TODO What does buffer = event.buf do?
    keymaps = {
      diagnostic."<leader>q" = {
        action = "setloclist";
        desc = "Open diagnostic [Q]uickfix list";
      };
      lspBuf = {
        "<leader>rn" = {
          action = "rename";
          desc = "LSP: [R]e[n]ame";
        };
        "<leader>ca" = {
          action = "code_action";
          desc = "LSP: [C]ode [A]ction";
        };
        gD = {
          action = "declaration";
          desc = "LSP: [G]oto [D]eclaration";
        };
      };
      extra = [
        {
          mode = "n";
          key = "gd";
          action.__raw = "require('telescope.builtin').lsp_definitions";
          options.desc = "LSP: [G]oto [D]efinition";
        }
        {
          mode = "n";
          key = "<leader>sd";
          action = "diagnostics";
          options.desc = "Search Diagnostics";
        }
        {
          mode = "n";
          key = "gr";
          action.__raw = "require('telescope.builtin').lsp_references";
          options.desc = "LSP: [G]oto [R]eferences";
        }
        {
          mode = "n";
          key = "gI";
          action.__raw = "require('telescope.builtin').lsp_implementations";
          options.desc = "LSP: [G]oto [I]mplementation";
        }
        {
          mode = "n";
          key = "<leader>D";
          action.__raw = "require('telescope.builtin').lsp_type_definitions";
          options.desc = "LSP: Type [D]efinition";
        }
        {
          mode = "n";
          key = "<leader>ds";
          action.__raw = "require('telescope.builtin').lsp_document_symbols";
          options.desc = "LSP: [D]ocument [S]ymbols";
        }
        {
          mode = "n";
          key = "<leader>ws";
          action.__raw = "require('telescope.builtin').lsp_dynamic_workspace_symbols";
          options.desc = "LSP: [W]orkspace [S]ymbols";
        }
      ];
    };

    # TODO
    # onAttach = ''
    #   -- The following two autocommands are used to highlight references of the
    #   -- word under your cursor when your cursor rests there for a little while.
    #   --    See `:help CursorHold` for information about when this is executed
    #   --
    #   -- When you move your cursor, the highlights will be cleared (the second autocommand).
    #   local client = vim.lsp.get_client_by_id(event.data.client_id)
    #   if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
    #     local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
    #     vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    #       buffer = event.buf,
    #       group = highlight_augroup,
    #       callback = vim.lsp.buf.document_highlight,
    #     })

    #     vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    #       buffer = event.buf,
    #       group = highlight_augroup,
    #       callback = vim.lsp.buf.clear_references,
    #     })

    #     vim.api.nvim_create_autocmd('LspDetach', {
    #       group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
    #       callback = function(event2)
    #         vim.lsp.buf.clear_references()
    #         vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
    #       end,
    #     })
    #   end

    #   -- The following code creates a keymap to toggle inlay hints in your
    #   -- code, if the language server you are using supports them
    #   --
    #   -- This may be unwanted, since they displace some of your code
    #   if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
    #     map('<leader>th', function()
    #       vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
    #     end, '[T]oggle Inlay [H]ints')
    #   end
    # '';
  };
}
