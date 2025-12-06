return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local custom_default = require("denys.plugins.lualine-theme.default")
    lualine.setup({
      options = {
        theme = custom_default,
        section_separators = { left = " ", right = "" },
        component_separators = { left = "❘", right = "❘" },
        disabled_filetypes = {
          statusline = {
            "NvimTree",
            "spectre_panel",
            "help",
            "alpha",
            "lazy",
            "packer",
            "trouble",
            "Trouble",
            "undotree",
          },
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = {
          "mode",
        },

        lualine_b = {},
        lualine_c = {
          "progress",
          "filename",
          {
            "diagnostics",
            sources = { "nvim_diagnostic", "nvim_lsp" },
            sections = { "error", "warn", "info", "hint" },
            diagnostics_color = {
              error = "DiagnosticError",
              warn = "DiagnosticWarn",
              info = "DiagnosticInfo",
              hint = "DiagnosticHint",
            },
            symbols = { error = "󰅙 ", warn = " ", info = " ", hint = "󰌵 " },
            colored = true,
            update_in_insert = false,
            always_visible = false,
          },
        },

        lualine_x = {},

        lualine_y = {
          {
            "diff",
            colored = false,
            symbols = { added = "󰐕 ", modified = " ", removed = " " },
            fmt = function(str)
              return str ~= "" and (" " .. str) or ""
            end,
          },
        },

        lualine_z = {
          {
            function()
              local branch = vim.b.gitsigns_head
              if not branch or branch == "" then
                return "󰊢 Git"
              end
              return " " .. branch
            end,
          },
        },
      },
    })
  end,
}
