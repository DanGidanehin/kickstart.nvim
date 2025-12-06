return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  opts = {
    options = {
      mode = "buffers",
      numbers = function(opts)
        local map = {
          "𝟭 ",
          "𝟮 ",
          "𝟯 ",
          "𝟰 ",
          "𝟱 ",
          "𝟲 ",
          "𝟳 ",
          "𝟴 ",
          "𝟵 ",
          "𝟭𝟬 ",
          "𝟭𝟭 ",
          "𝟭𝟮 ",
          "𝟭𝟯 ",
          "𝟭𝟰 ",
          "𝟭𝟱 ",
          "𝟭𝟲 ",
          "𝟭𝟳 ",
          "𝟭𝟴 ",
          "𝟭𝟵 ",
          "𝟮𝟬 ",
          "𝟮𝟭 ",
          "𝟮𝟮 ",
          "𝟮𝟯 ",
          "𝟮𝟰 ",
          "𝟮𝟱 ",
          "𝟮𝟲 ",
          "𝟮𝟳 ",
          "𝟮𝟴 ",
          "𝟮𝟵 ",
          "𝟯𝟬 ",
          "𝟯𝟭 ",
          "𝟯𝟮 ",
          "𝟯𝟯 ",
          "𝟯𝟰 ",
          "𝟯𝟱 ",
          "𝟯𝟲 ",
          "𝟯𝟳 ",
          "𝟯𝟴 ",
          "𝟯𝟵 ",
          "𝟰𝟬 ",
          "𝟰𝟭 ",
          "𝟰𝟮 ",
          "𝟰𝟯 ",
          "𝟰𝟰 ",
          "𝟰𝟱 ",
          "𝟰𝟲 ",
          "𝟰𝟳 ",
          "𝟰𝟴 ",
          "𝟰𝟵 ",
          "𝟱𝟬 ",
        }
        return map[opts.ordinal] or opts.ordinal
      end,
      modified_icon = "M",
      show_close_icon = false,
      show_buffer_close_icons = false,
      separator_style = { "❘", "❘" },
      indicator = { style = "none" },
    },
    highlights = {
      fill = { bg = "none" },
      background = { fg = "#627E97", bg = "none" },
      buffer_selected = { fg = "#65D1FF", bg = "none", bold = true },
      separator = { fg = "#547998", bg = "none" },
      separator_selected = { fg = "#65D1FF", bg = "none" },
      indicator_selected = { fg = "#65D1FF", bg = "none" },
      modified = { fg = "#41ddca", bg = "none" },
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)
    local keymap = vim.keymap

    -- New Empty Buffer
    keymap.set("n", "<leader>bo", "<cmd>enew<CR>", { desc = "Open new empty buffer" })
    -- Close Current Buffer
    keymap.set("n", "<leader>bx", "<cmd>bdelete<CR>", { desc = "Close current buffer" })
    -- Navigate Next/Prev
    keymap.set("n", "<leader>bn", "<cmd>BufferLineCycleNext<CR>", { desc = "Go to next buffer" })
    keymap.set("n", "<leader>bp", "<cmd>BufferLineCyclePrev<CR>", { desc = "Go to previous buffer" })
    -- Jump to specific buffer (1-9)
    for i = 1, 9 do
      keymap.set("n", "<leader>b" .. i, function()
        require("bufferline").go_to(i, true)
      end, { desc = "Go to buffer " .. i })
    end
    -- Jump to last buffer
    keymap.set("n", "<leader>b0", "<cmd>BufferLineGoToBuffer -1<CR>", { desc = "Go to last buffer" })
  end,
}
