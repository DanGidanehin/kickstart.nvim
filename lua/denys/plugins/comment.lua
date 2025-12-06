return {
  "numToStr/Comment.nvim",
  lazy = false,
  dependencies = {
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      event = "VeryLazy",
    },
  },

  config = function()
    -- Setup Context Commentstring (For React/Vue/Svelte support)
    vim.g.skip_ts_context_commentstring_module = true
    ---@diagnostic disable: missing-fields
    require("ts_context_commentstring").setup({
      enable_autocmd = false,
    })

    -- Setup Comment.nvim
    local comment = require("Comment")
    local api = require("Comment.api")

    comment.setup({
      padding = true,
      sticky = true,

      -- Disable ALL default mappings (gcc, gbc, etc.)
      mappings = {
        basic = false,
        extra = false,
      },

      -- Enable context awareness
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    })

    -- Custom Simplified Keymaps
    local keymap = vim.keymap.set

    -- Toggle Line Comment
    keymap("n", "<leader>kc", api.toggle.linewise.current, { desc = "Toggle line comment" })
    keymap("x", "<leader>kc", "<Plug>(comment_toggle_linewise_visual)", { desc = "Toggle line comment" })
    -- Toggle Block Comment
    keymap("n", "<leader>kb", api.toggle.blockwise.current, { desc = "Toggle block comment" })
    keymap("x", "<leader>kb", "<Plug>(comment_toggle_blockwise_visual)", { desc = "Toggle block comment" })

    -- Add Comment Below
    keymap("n", "<leader>ko", function()
      api.insert.linewise.below()
    end, { desc = "Comment line below" })
    -- Add Comment Above
    keymap("n", "<leader>kO", function()
      api.insert.linewise.above()
    end, { desc = "Comment line above" })
    -- Add Comment at End of Line
    keymap("n", "<leader>ke", function()
      api.insert.linewise.eol()
    end, { desc = "Comment end of line" })
  end,
}
