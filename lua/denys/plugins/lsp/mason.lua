-- lua/denys/plugins/lsp/mason.lua
return {
  enabled = false,
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
        "sqlfluff",
        -- Linters
        "ktlint",
        "pylint",
        "eslint_d",
        "shellcheck",
        "stylelint",
      },
    },
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
}
