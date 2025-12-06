return {
  "rmagatti/auto-session",
  config = function()
    local auto_session = require("auto-session")

    auto_session.setup({
      auto_restore_enabled = true,
      auto_save_enabled = true,
      auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
    })

    local keymap = vim.keymap

    -- Delete Session & Quit
    keymap.set("n", "<leader>qd", function()
      vim.cmd("SessionDelete")
      vim.cmd("qa")
    end, { desc = "Delete session and quit" })
  end,
}
