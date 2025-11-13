-- return {
--   "nvim-pack/nvim-spectre",
--   dependencies = { "nvim-lua/plenary.nvim" },
--   config = function()
--     local spectre = require("spectre")
--
--     spectre.setup({
--       default = {
--         find = { cmd = "rg" }, -- use ripgrep
--         replace = { cmd = "sed" }, -- use system sed
--       },
--     })
--
--     local map = vim.keymap
--     map.set("n", "<leader>sr", spectre.open, { desc = "Open Spectre panel" })
--     map.set("v", "<leader>sr", spectre.open_visual, { desc = "Search selection" })
--     map.set("n", "<leader>sf", spectre.open_file_search, { desc = "Search in current file" })
--     map.set("n", "<leader>ri", function()
--       spectre.change_options("ignore-case")
--     end, { desc = "Spectre: Toggle ignore case" })
--   end,
-- }

return {
  "nvim-pack/nvim-spectre",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local spectre = require("spectre")

    spectre.setup({
      default = {
        find = { cmd = "rg" },
        replace = { cmd = "sed" },
      },
      ui = {
        -- THIS IS THE KEY CHANGE:
        -- 1. We use `vnew` (or `vsplit`) to create a vertical window.
        -- 2. We prefix it with `right` to force the window to open on the far right.
        -- 3. We use `noswapfile` to prevent creating unnecessary swap files for the Spectre buffer.
        open_cmd = "right noswapfile vnew",

        -- Keep this to fix the E37 error
        result_enter_best_match = "edit_no_buffer_check",
      },
    })

    local keymap = vim.keymap

    -- Using spectre.toggle to open/close
    keymap.set("n", "<leader>sr", spectre.toggle, { desc = "Toggle Spectre panel (Far Right Split)" })

    -- Keep existing mappings
    keymap.set("v", "<leader>sr", spectre.open_visual, { desc = "Search selection" })
    keymap.set("n", "<leader>sf", spectre.open_file_search, { desc = "Search in current file" })
    keymap.set("n", "<leader>ri", function()
      spectre.change_options("ignore-case")
    end, { desc = "Spectre: Toggle ignore case" })
  end,
}
