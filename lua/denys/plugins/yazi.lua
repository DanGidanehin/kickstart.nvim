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
  },
  opts = {
    open_for_directories = false,
  },
}
