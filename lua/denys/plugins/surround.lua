return {
  "kylechui/nvim-surround",
  version = "*",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    keymaps = {
      normal_cur_line = "<leader>yS",

      visual = "<leader>ys",
      visual_line = "<leader>yS",

      -- Change/Delete
      delete = "<leader>ds",
      change = "<leader>cs",
    },
  },
}
