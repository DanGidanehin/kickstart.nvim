return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  opts = {
    options = {
      mode = "tabs",
      show_close_icon = false,
      show_buffer_close_icons = false,
      separator_style = "thin",
    },
    highlights = {
      fill = { bg = "none" },
      background = { fg = "#627E97", bg = "none" },
      tab = { fg = "#B4D0E9", bg = "none" },

      tab_selected = { fg = "#FFFFFF", bg = "#21CAFA", bold = true },
      tab_separator_selected = { fg = "#21CAFA", bg = "none" },
      indicator_selected = { fg = "#21CAFA", bg = "none" },

      tab_separator = { fg = "#547998", bg = "none" },
      modified = { fg = "#CBE0F0", bg = "none" },
    },
  },
}

-- }-- return {
--   "akinsho/bufferline.nvim",
--   dependencies = { "nvim-tree/nvim-web-devicons" },
--   version = "*",
--   opts = {
--     options = {
--       mode = "tabs",
--       show_close_icon = false,
--       show_buffer_close_icons = false,
--       separator_style = "thin",
--     },
--     highlights = {
--       fill = { bg = "none" },
--       background = { fg = "#627E97", bg = "none" },
--       tab = { fg = "#B4D0E9", bg = "none" },
--       tab_selected = { fg = "#CBE0F0", bg = "#0A64AC", bold = true },
--       tab_separator = { fg = "#547998", bg = "none" },
--       tab_separator_selected = { fg = "#0A64AC", bg = "none" },
--       indicator_selected = { fg = "#0A64AC", bg = "none" },
--       modified = { fg = "#CBE0F0", bg = "none" },
--     },
--   },
-- }
