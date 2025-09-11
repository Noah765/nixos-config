{
  lib,
  pkgs,
  ...
}: {
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
      folder.aliases.inbox = "INBOX";
      folder.aliases.sent = "Gesendet";
      folder.aliases.drafts = "Entwürfe";
      folder.aliases.trash = "Gelöscht";
      backend.type = "imap";
      backend.host = "imap.gmx.net";
      backend.port = 993;
      backend.login = "noah.landgraf@gmx.de";
      backend.encryption.type = "tls";
      backend.auth.type = "password";
      backend.auth.cmd = "${pkgs.coreutils}/bin/cat ~/.cache/nvim/himalaya-gmx.txt";
      message.send.backend.type = "smtp";
      message.send.backend.host = "mail.gmx.net";
      message.send.backend.port = 587;
      message.send.backend.login = "noah.landgraf@gmx.de";
      message.send.backend.encryption.type = "start-tls";
      message.send.backend.auth.type = "password";
      message.send.backend.auth.cmd = "${pkgs.coreutils}/bin/cat ~/.cache/nvim/himalaya-gmx.txt";
    };
  };

  keymaps = lib.singleton {
    key = "<leader>h";
    mode = "n";
    action = lib.nixvim.utils.mkRaw ''
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
}
