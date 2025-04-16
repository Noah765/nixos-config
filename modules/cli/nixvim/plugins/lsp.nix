{
  lib,
  pkgs,
  configName,
  ...
}:
with lib; {
  hm.programs.nixvim.plugins.lsp = {
    enable = true;
    inlayHints = true;
    servers.nixd = {
      enable = true;
      settings = {
        formatting.command = [(getExe pkgs.alejandra)];
        options.modulix.expr = "(builtins.getFlake \"/etc/nixos\").modulixConfigurations.${configName}.options";
      };
    };
    # TODO Modify / remove bindings as needed
    keymaps = {
      diagnostic."<leader>q" = {
        action = "setloclist";
        desc = "Open diagnostic Quickfix list";
      };
      lspBuf = {
        "<leader>rn" = {
          action = "rename";
          desc = "LSP: Rename";
        };
        "<leader>ca" = {
          action = "code_action";
          desc = "LSP: Code Action";
        };
        gD = {
          action = "declaration";
          desc = "LSP: Goto Declaration";
        };
      };
      extra = [
        {
          mode = "n";
          key = "gd";
          action.__raw = "require('telescope.builtin').lsp_definitions";
          options.desc = "LSP: Goto Definition";
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
          options.desc = "LSP: Goto References";
        }
        {
          mode = "n";
          key = "gI";
          action.__raw = "require('telescope.builtin').lsp_implementations";
          options.desc = "LSP: Goto Implementation";
        }
        {
          mode = "n";
          key = "<leader>D";
          action.__raw = "require('telescope.builtin').lsp_type_definitions";
          options.desc = "LSP: Type Definition";
        }
        {
          mode = "n";
          key = "<leader>ds";
          action.__raw = "require('telescope.builtin').lsp_document_symbols";
          options.desc = "LSP: Document Symbols";
        }
        {
          mode = "n";
          key = "<leader>ws";
          action.__raw = "require('telescope.builtin').lsp_dynamic_workspace_symbols";
          options.desc = "LSP: Workspace Symbols";
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
    #     end, 'Toggle Inlay Hints')
    #   end
    # '';
  };
}
