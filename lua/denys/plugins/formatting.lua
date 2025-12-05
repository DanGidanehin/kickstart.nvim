-- lua/denys/plugins/formatting.lua
return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        -- C / C++
        c = { "clang-format" },
        cpp = { "clang-format" },
        -- C#
        cs = { "csharpier" },
        -- Python
        python = { "isort", "black" },
        -- JS/TS/General Web
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        liquid = { "prettier" },
        -- Rust
        rust = { "rust_analyzer" },
        -- SQL
        sql = { "sqlfluff" },
        -- Lua
        lua = { "stylua" },
      },
      format_on_save = {
        lsp_fallback = true, -- ESSENTIAL for Java, Kotlin, and now Swift
        async = false,
        timeout_ms = 3000,
      },
    })

    local keymap = vim.keymap

    keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
