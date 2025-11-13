-- return {
--   {
--     "williamboman/mason-lspconfig.nvim",
--     opts = {
--       -- list of servers for mason to install
--       ensure_installed = {
--         "ts_ls",
--         "html",
--         "cssls",
--         "tailwindcss",
--         "svelte",
--         "lua_ls",
--         "graphql",
--         "emmet_ls",
--         "prismals",
--         "pyright",
--         "eslint",
--       },
--     },
--     dependencies = {
--       {
--         "williamboman/mason.nvim",
--         opts = {
--           ui = {
--             icons = {
--               package_installed = "✓",
--               package_pending = "➜",
--               package_uninstalled = "✗",
--             },
--           },
--         },
--       },
--       "neovim/nvim-lspconfig",
--     },
--   },
--   {
--     "WhoIsSethDaniel/mason-tool-installer.nvim",
--     opts = {
--       ensure_installed = {
--         "prettier", -- prettier formatter
--         "stylua", -- lua formatter
--         "isort", -- python formatter
--         "black", -- python formatter
--         "pylint",
--         "eslint_d",
--       },
--     },
--     dependencies = {
--       "williamboman/mason.nvim",
--     },
--   },
-- }

-- lua/denys/plugins/lsp/mason.lua
return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- List of servers for mason to install (MUST BE nvim-lspconfig names)
      ensure_installed = {
        "clangd",
        "omnisharp",
        "pyright",
        "html",
        "cssls",
        "tailwindcss",
        "svelte",
        "jsonls",
        "eslint",
        "jdtls",
        "rust_analyzer",
        "kotlin_language_server",
        "sqlls",
        "lua_ls",
        "graphql",
        "emmet_ls",
        "prismals",
      },
      automatic_installation = true,
    },
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- Formatters
        "prettier",
        "stylua",
        "isort",
        "black",
        "clang-format",
        "csharpier",
        "rustfmt",
        "sqlfluff",
        "ktlint",
        -- Removed "dotnet-sdk"

        -- Linters
        "pylint",
        "eslint_d",
        "shellcheck",
        "stylelint",
        "cpplint",
      },
    },
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
}
