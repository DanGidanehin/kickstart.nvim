return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>yz",
      function()
        require("yazi").yazi()
      end,
      desc = "Open Yazi",
    },
    {
      "<leader>yc",
      function()
        require("yazi").yazi(nil, vim.fn.getcwd())
      end,
      desc = "Open Yazi in working directory",
    },
  },
  opts = {
    open_for_directories = false,
    keymaps = {
      show_help = "<f1>",
    },
  },
}
