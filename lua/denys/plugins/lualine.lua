return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")

    local colors = {
      blue = "#65D1FF",
      green = "#3EFFDC",
      violet = "#FF61EF",
      yellow = "#FFDA7B",
      red = "#FF4A4A",
      fg = "#c3ccdc",
      bg = "#112638",
      inactive_bg = "#2c3043",
      semilightgray = "#8b8fa9",
    }

    local my_lualine_theme = {
      normal = {
        a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      insert = {
        a = { bg = colors.green, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      visual = {
        a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      command = {
        a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      replace = {
        a = { bg = colors.red, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      inactive = {
        a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
        b = { bg = colors.inactive_bg, fg = colors.semilightgray },
        c = { bg = colors.inactive_bg, fg = colors.semilightgray },
      },
    }

    local function short_path()
      local path = vim.fn.expand("%:p")
      if path == "" then
        return ""
      end
      local parts = vim.split(path, "/")
      local count = #parts
      local start = math.max(count - 0, 1)
      local short = table.concat(vim.list_slice(parts, start, count), "/")
      return short
    end

    lualine.setup({
      options = {
        theme = my_lualine_theme,
        section_separators = { left = " ", right = "" },
        component_separators = { left = "❘", right = "❘" },
        disabled_filetypes = {
          statusline = { "NvimTree", "spectre_panel", "help", "alpha", "lazy", "packer", "trouble", "Trouble" },
        },
      },
      sections = {
        lualine_a = {
          {
            function()
              local branch = vim.b.gitsigns_head
              if not branch or branch == "" then
                return "󰊢 Git"
              end
              return " " .. branch
            end,
          },
          {
            "diff",
            colored = false,
            symbols = { added = "󰐕 ", modified = " ", removed = " " },
            fmt = function(str)
              return str ~= "" and (" " .. str) or ""
            end,
          },
        },
        lualine_b = {},
        lualine_c = {
          { short_path, icon = "", separator = "" },
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            padding = { left = 0, right = 0 },
            separator = "",
            symbols = { error = "󰅙 ", warn = " ", info = " " },
          },
        },

        lualine_x = {
          { "progress" },
        },

        lualine_y = {},

        lualine_z = { "mode" },
      },
    })
  end,
}
