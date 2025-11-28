-- lua/denys/plugins/lsp/lspconfig.lua
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "williamboman/mason-lspconfig.nvim",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/lazydev.nvim", opts = {} },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    -- Signs & basic diagnostics UI
    local signs = { Error = "󰅙 ", Warn = " ", Hint = "󰌵 ", Info = " " }
    vim.diagnostic.config({
      signs = {
        active = true,
        text = {
          [vim.diagnostic.severity.ERROR] = signs.Error,
          [vim.diagnostic.severity.WARN] = signs.Warn,
          [vim.diagnostic.severity.HINT] = signs.Hint,
          [vim.diagnostic.severity.INFO] = signs.Info,
        },
      },
      update_in_insert = false,
      virtual_text = true,
      severity_sort = true,
    })

    -- 🔇 Global filter: drop cspell/unknown-word diagnostics from any server
    do
      local orig = vim.lsp.handlers["textDocument/publishDiagnostics"]
      vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, conf)
        if result and result.diagnostics then
          local filtered = {}
          for _, d in ipairs(result.diagnostics) do
            local src = (d.source or ""):lower()
            local code = (type(d.code) == "string" and d.code or ""):lower()
            -- filter typical spell hits
            if not (src == "cspell" or src == "cspell_ls" or code:find("unknown") or code:find("spelling")) then
              table.insert(filtered, d)
            end
          end
          result.diagnostics = filtered
        end
        return orig(err, result, ctx, conf)
      end
    end

    -- If cspell attaches anyway (e.g., via another plugin), stop it immediately.
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
          return
        end
        local name = client.name or ""
        if name == "cspell" or name == "cspell_ls" then
          vim.lsp.stop_client(client.id, true)
        end
      end,
    })
    -- Capabilities for completion
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Servers you want
    local servers = {
      "clangd",
      "omnisharp",
      "pyright",
      "html",
      "cssls",
      "tailwindcss",
      "svelte",
      "eslint",
      "jsonls",
      "jdtls",
      "rust_analyzer",
      "kotlin_language_server",
      "sqlls",
      "lua_ls",
      "graphql",
      "emmet_ls",
      "prismals",
    }

    mason_lspconfig.setup({
      ensure_installed = servers,
      handlers = {
        function(server)
          lspconfig[server].setup({ capabilities = capabilities })
        end,

        ["clangd"] = function()
          lspconfig.clangd.setup({
            capabilities = capabilities,
            cmd = {
              "clangd",
              "--background-index",
              "--clang-tidy=false",
            },
          })
        end,

        -- C#
        ["omnisharp"] = function()
          local omnisharp_path = vim.fn.stdpath("data") .. "/mason/bin/omnisharp"
          if vim.fn.executable(omnisharp_path) == 1 then
            lspconfig.omnisharp.setup({
              capabilities = capabilities,
              cmd = { omnisharp_path },
              root_dir = require("lspconfig.util").root_pattern("*.sln", ".git", "omnisharp.json"),
              enable_import_completion = true,
            })
          else
            vim.notify(
              "OmniSharp not found (Mason). Install .NET SDK and :Mason install omnisharp.",
              vim.log.levels.WARN
            )
          end
        end,

        -- Java (minimal; jdtls often needs project-specific setup)
        ["jdtls"] = function()
          lspconfig.jdtls.setup({ capabilities = capabilities })
        end,

        -- Lua: also silence any spell-related checks from lua_ls (belt & suspenders)
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = { disable = { "spell" } },
                workspace = { checkThirdParty = false },
              },
            },
          })
        end,
      },
    })
  end,
}
