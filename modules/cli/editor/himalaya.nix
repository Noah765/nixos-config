{
  lib,
  pkgs,
  config,
  ...
}: {
  options.cli.editor.himalaya.enable = lib.mkEnableOption "the himalaya email client";

  config.cli.editor.settings = lib.mkIf config.cli.editor.himalaya.enable {
    extraPlugins = [pkgs.vimPlugins.himalaya-vim];

    # TODO himalaya_complete_contact_cmd

    globals.himalaya_executable = lib.getExe pkgs.himalaya;

    globals.himalaya_config_path = (pkgs.formats.toml {}).generate "himalaya.config.toml" {
      display-name = "Noah Landgraf";
      signature = "Mit freundlichen Grüßen,\nNoah Landgraf";
      signature-delim = "";
      # TODO account.list.table;
      accounts.gmx = {
        default = true;
        email = "noah.landgraf@gmx.de";
        # TODO folder, envelope, message, template, pgp;
        folder.aliases = {
          inbox = "INBOX";
          sent = "Gesendet";
          drafts = "Entwürfe";
          trash = "Gelöscht";
        };
        backend = {
          type = "imap";
          host = "imap.gmx.net";
          port = 993;
          login = "noah.landgraf@gmx.de";
          encryption.type = "tls";
          auth.type = "password";
          auth.cmd = "${pkgs.coreutils}/bin/cat ~/.cache/nvim/himalaya-gmx.txt";
        };
        message.send.backend = {
          type = "smtp";
          host = "mail.gmx.net";
          port = 587;
          login = "noah.landgraf@gmx.de";
          encryption.type = "start-tls";
          auth.type = "password";
          auth.cmd = "${pkgs.coreutils}/bin/cat ~/.cache/nvim/himalaya-gmx.txt";
        };
      };
    };

    keymaps = lib.singleton {
      key = "<leader>h";
      mode = "n";
      action = config.hm.lib.nixvim.utils.mkRaw ''
        function()
          local output = vim.system({'pass', 'gmx/nixos'}, { text = true }):wait()
          if output.code ~= 0 then error(output.stderr) end

          local file_path = vim.fn.stdpath('cache') .. '/himalaya-gmx.txt'
          local file, error_message = io.open(file_path, 'w')
          if not file then error(error_message) end
          file:write(output.stdout)
          file:close()

          vim.cmd.Himalaya()

          vim.api.nvim_create_autocmd('VimLeave', { callback = function() os.remove(file_path) end })
        end
      '';
      options.desc = "Himalaya";
    };
  };
}
