return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    -- Add current file to the list
    vim.keymap.set("n", "<leader>ha", function()
      harpoon:list():add()
      vim.notify("󱡅  Marked file")
    end, { desc = "Harpoon: Mark file" })
    -- Remove file from harpoon
    vim.keymap.set("n", "<leader>hd", function()
      harpoon:list():remove()
      vim.notify("Removed from Harpoon")
    end, { desc = "Harpoon: Remove file" })
    -- Toggle the quick menu
    vim.keymap.set("n", "<C-e>", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon: Toggle Menu" })

    -- Navigation (Jump to file 1, 2, 3, 4, 5, 6, 7, 8)
    vim.keymap.set("n", "<leader>1", function()
      harpoon:list():select(1)
    end, { desc = "Harpoon: Jump to 1" })
    vim.keymap.set("n", "<leader>2", function()
      harpoon:list():select(2)
    end, { desc = "Harpoon: Jump to 2" })
    vim.keymap.set("n", "<leader>3", function()
      harpoon:list():select(3)
    end, { desc = "Harpoon: Jump to 3" })
    vim.keymap.set("n", "<leader>4", function()
      harpoon:list():select(4)
    end, { desc = "Harpoon: Jump to 4" })
    vim.keymap.set("n", "<leader>5", function()
      harpoon:list():select(5)
    end, { desc = "Harpoon: Jump to 5" })
    vim.keymap.set("n", "<leader>6", function()
      harpoon:list():select(6)
    end, { desc = "Harpoon: Jump to 6" })
    vim.keymap.set("n", "<leader>7", function()
      harpoon:list():select(7)
    end, { desc = "Harpoon: Jump to 7" })
    vim.keymap.set("n", "<leader>8", function()
      harpoon:list():select(8)
    end, { desc = "Harpoon: Jump to 8" })
  end,
}
