return {
  {
    "neoclide/coc.nvim",
    branch = "release",
    event = { "BufReadPre", "BufNewFile" },

    init = function()
      vim.g.coc_global_extensions = {
        "coc-json",
        "coc-tsserver",
        "coc-html",
        "coc-css",
        "coc-java",
        "coc-pyright",
        "coc-clangd",
        "coc-omnisharp",
        "coc-kotlin",
        "coc-sql",
        "coc-rust-analyzer",
        "coc-go",
        "coc-prettier",
        "coc-snippets",
        "coc-sh",
        "coc-lua",
      }
    end,

    config = function()
      -- Custom Signs
      vim.fn.sign_define("CocErrorSign", { text = "✘", texthl = "CocErrorSign", linehl = "", numhl = "" })
      vim.fn.sign_define("CocWarningSign", { text = "⚠", texthl = "CocWarningSign", linehl = "", numhl = "" })
      vim.fn.sign_define("CocInfoSign", { text = "ℹ", texthl = "CocInfoSign", linehl = "", numhl = "" })
      vim.fn.sign_define("CocHintSign", { text = "", texthl = "CocHintSign", linehl = "", numhl = "" })
      local keyset = vim.keymap.set

      -- Autocomplete
      local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
      function _G.check_back_space()
        local col = vim.fn.col(".") - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
      end
      keyset(
        "i",
        "<TAB>",
        'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
        opts
      )
      keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
      keyset("i", "<CR>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

      -- Navigation
      keyset("n", "gd", "<Plug>(coc-definition)", { silent = true, desc = "Go to Definition" })
      keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true, desc = "Go to Type Definition" })
      keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true, desc = "Go to Implementation" })
      keyset("n", "gr", "<Plug>(coc-references)", { silent = true, desc = "Find References" })
      -- Hover documentation
      function _G.show_docs()
        local cw = vim.fn.expand("<cword>")
        if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
          vim.api.nvim_command("h " .. cw)
        elseif vim.api.nvim_eval("coc#rpc#ready()") then
          vim.fn.CocActionAsync("doHover")
        else
          vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
        end
      end
      keyset("n", "H", "<CMD>lua _G.show_docs()<CR>", { silent = true, desc = "Show Documentation" })

      -- Diagnostics
      keyset("n", "[d", "<Plug>(coc-diagnostic-prev)", { silent = true, desc = "Previous Diagnostic" })
      keyset("n", "]d", "<Plug>(coc-diagnostic-next)", { silent = true, desc = "Next Diagnostic" })
      keyset(
        "n",
        "<space>dg",
        ":<C-u>CocList diagnostics<cr>",
        { silent = true, nowait = true, desc = "List Diagnostics" }
      )
      -- Lists
      keyset("n", "<space>sy", ":<C-u>CocList -I symbols<cr>", { silent = true, nowait = true, desc = "List Symbols" })
      keyset("n", "<space>ol", ":<C-u>CocList outline<cr>", { silent = true, nowait = true, desc = "Show Outline" })
      -- Codelens
      keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", { silent = true, desc = "Run Code Lens" })
      -- Refactor / Actions
      keyset("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true, desc = "Rename Symbol" })
      keyset("n", "<leader>rf", "<Plug>(coc-refactor)", { silent = true, desc = "Refactor Current File" })
      keyset("n", "<leader>ca", "<Plug>(coc-codeaction)", { silent = true, desc = "Code Action" })
      keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", { silent = true, desc = "Quick Fix" })
    end,
  },
}
