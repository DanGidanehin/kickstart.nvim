-- lua/plugins/comment.lua
return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    -- Optional but recommended to get proper TSX/CSS/HTML context:
    -- "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    -- ts-context-commentstring: let Comment.nvim drive updates (no autocmd)
    vim.g.skip_ts_context_commentstring_module = true
    require("ts_context_commentstring").setup({
      enable_autocmd = false,
    })

    -- Comment.nvim + integration hook
    local ts_integration = require("ts_context_commentstring.integrations.comment_nvim")
    require("Comment").setup({
      mappings = false, -- we'll define our own keymaps below
      pre_hook = ts_integration.create_pre_hook(),
    })

    -- Keymaps
    local api = require("Comment.api")
    local keymap = vim.keymap
    local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)

    -- Leader mappings (filetype-aware via ts-context-commentstring)
    -- Normal mode
    keymap.set("n", "<leader>kc", function()
      api.toggle.linewise.current()
    end, { desc = "Comment current line (ft-aware)" })

    keymap.set("n", "<leader>kC", function()
      api.toggle.blockwise.current()
    end, { desc = "Block-comment current line (ft-aware)" })

    -- Use same toggle for uncomment
    keymap.set("n", "<leader>ku", function()
      api.toggle.linewise.current()
    end, { desc = "Un/Comment current line (ft-aware)" })

    -- Visual mode (selection)
    keymap.set("x", "<leader>kc", function()
      vim.api.nvim_feedkeys(esc, "nx", false)
      api.toggle.linewise(vim.fn.visualmode())
    end, { desc = "Comment selection (ft-aware)" })

    keymap.set("x", "<leader>kC", function()
      vim.api.nvim_feedkeys(esc, "nx", false)
      api.toggle.blockwise(vim.fn.visualmode())
    end, { desc = "Block-comment selection (ft-aware)" })

    keymap.set("x", "<leader>ku", function()
      vim.api.nvim_feedkeys(esc, "nx", false)
      api.toggle.linewise(vim.fn.visualmode())
    end, { desc = "Un/Comment selection (ft-aware)" })

    -- Familiar defaults (since mappings=false above disables Comment.nvim defaults)
    -- Feel free to remove if you only want the <leader> mappings.
    keymap.set("n", "gcc", function()
      api.toggle.linewise.current()
    end, { desc = "Comment line" })
    keymap.set("n", "gbc", function()
      api.toggle.blockwise.current()
    end, { desc = "Block comment line" })
    keymap.set("x", "gc", function()
      api.toggle.linewise(vim.fn.visualmode())
    end, { desc = "Comment selection" })
    keymap.set("x", "gb", function()
      api.toggle.blockwise(vim.fn.visualmode())
    end, { desc = "Block comment selection" })
  end,
}
