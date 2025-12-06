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
      local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }

      -- Autocomplete (Tab / Shift-Tab / Enter)
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
      keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
      keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
      keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
      keyset("n", "gr", "<Plug>(coc-references)", { silent = true })

      -- Documentation (Hover)
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
      keyset("n", "K", "<CMD>lua _G.show_docs()<CR>", { silent = true })

      -- Actions
      keyset("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })
      keyset("x", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
      keyset("n", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })

      -- Diagnostics
      keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
      keyset("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })
      keyset("n", "<leader>ac", "<Plug>(coc-codeaction)", { silent = true })
      keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", { silent = true })

      -- Lists
      keyset("n", "<space>d", ":<C-u>CocList diagnostics<cr>", { silent = true, nowait = true })
      keyset("n", "<space>s", ":<C-u>CocList -I symbols<cr>", { silent = true, nowait = true })
      keyset("n", "<space>o", ":<C-u>CocList outline<cr>", { silent = true, nowait = true })

      -- Code Lens
      keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", { silent = true })
    end,
  },
}
