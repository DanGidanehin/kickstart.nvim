return {
  "nvim-pack/nvim-spectre",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local spectre = require("spectre")

    spectre.setup({
      default = {
        find = { cmd = "rg" }, -- use ripgrep
        replace = { cmd = "sed" }, -- use system sed
      },
    })

    local map = vim.keymap
    map.set("n", "<leader>sr", spectre.open, { desc = "Open Spectre panel" })
    map.set("v", "<leader>sr", spectre.open_visual, { desc = "Search selection" })
    map.set("n", "<leader>sf", spectre.open_file_search, { desc = "Search in current file" })
    map.set("n", "<leader>ri", function()
      spectre.change_options("ignore-case")
    end, { desc = "Spectre: Toggle ignore case" })
  end,
}

-- return {
--   "nvim-pack/nvim-spectre",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     "nvim-tree/nvim-web-devicons",
--   },
--   config = function()
--     local spectre = require("spectre")
--     local actions = require("spectre.actions")
--
--     spectre.setup()
--
--     local map = vim.keymap
--
--     -- Search
--     map.set("n", "<leader>sr", spectre.open, { desc = "Spectre: Toggle panel" })
--     map.set("v", "<leader>sr", spectre.open_visual, { desc = "Spectre: Search selection" })
--     map.set("n", "<leader>sf", spectre.open_file_search, { desc = "Spectre: Search in current file" })
--
--     -- Replace
--     map.set("n", "<leader>rc", actions.run_current_replace, { desc = "Spectre: Replace current file" })
--     map.set("n", "<leader>ra", actions.run_replace, { desc = "Spectre: Replace all selected" })
--     map.set("n", "<leader>ri", function()
--       spectre.change_options("ignore-case")
--     end, { desc = "Spectre: Toggle ignore case" })
--   end,
-- }
