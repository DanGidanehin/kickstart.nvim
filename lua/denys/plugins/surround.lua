-- Make sure your leader is set early in your config:
-- vim.g.mapleader = " "

return {
  "kylechui/nvim-surround",
  version = "*",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    -- Override defaults to use <leader>… everywhere
    keymaps = {
      normal_cur_line = "<leader>yS", -- whaps whole current line

      visual = "<leader>ys", -- select text, then <leader>ys)
      visual_line = "<leader>yS", -- linewise visual selection

      -- Change/Delete
      delete = "<leader>ds", -- e.g., <leader>ds)  -> remove ()
      change = "<leader>cs", -- e.g., <leader>cs" ' -> change "…"
    },
  },
}

-- return {
--   "kylechui/nvim-surround",
--   event = { "BufReadPre", "BufNewFile" },
--   version = "*", -- Use for stability; omit to use `main` branch for the latest features
--   config = true,
-- }
