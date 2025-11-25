return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    -- local lazy_status = require("lazy.status")

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
      -- keep last 3 segments (2 folders + filename)
      local start = math.max(count - 0, 1)
      local short = table.concat(vim.list_slice(parts, start, count), "/")
      return short
    end

    lualine.setup({
      options = {
        theme = my_lualine_theme,
        section_separators = { left = " ", right = "" },
        component_separators = { left = "❘", right = "❘" },
        -- 
        disabled_filetypes = {
          statusline = {
            "NvimTree", -- Exclude nvim-tree
            "spectre_panel", -- Exclude spectre
            "help", -- Good practice to exclude help files
            "alpha", -- If you use a dashboard
            "lazy",
            "packer",
            "trouble",
            "Trouble",
          },
        },
      },
      sections = {
        -- left: GitHub / Git
        lualine_a = {
          {
            function()
              local head = vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.head
              local file = vim.api.nvim_buf_get_name(0)
              local dir = (file ~= "" and vim.fn.fnamemodify(file, ":h")) or vim.fn.getcwd()

              -- Fallback: ask git directly
              if not head or head == "" then
                local out = vim.fn.systemlist({ "git", "-C", dir, "rev-parse", "--abbrev-ref", "HEAD" })
                if vim.v.shell_error == 0 and out[1] and out[1] ~= "" then
                  head = out[1]
                end
              end

              -- If detached HEAD, show short commit hash
              if head == "HEAD" then
                local commit = vim.fn.systemlist({ "git", "-C", dir, "rev-parse", "--short", "HEAD" })[1]
                if commit and commit ~= "" then
                  head = " " .. commit
                end
              elseif head and head ~= "" then
                head = " " .. head
              else
                head = "󰊢 Git"
              end

              -- Git diff signs (from gitsigns)
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                local added = gitsigns.added or 0
                local changed = gitsigns.changed or 0
                local removed = gitsigns.removed or 0
                local diff_str = ""

                if added > 0 then
                  diff_str = diff_str .. " 󰐕 " .. added
                end
                if changed > 0 then
                  diff_str = diff_str .. "  " .. changed
                end
                if removed > 0 then
                  diff_str = diff_str .. "  " .. removed
                end

                if diff_str ~= "" then
                  head = head .. diff_str
                end
              end

              return head
            end,
          },
        }, -- no diff / git here
        lualine_b = {},

        -- center: path
        lualine_c = {
          { short_path, icon = "", separator = "" },
          -- 
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            padding = { left = 0, right = 0 },
            separator = "",
            symbols = { error = "󰅙 ", warn = " ", info = " " },
          },
        },

        -- right side: filetype | percentage
        lualine_x = {
          -- { "filetype" },
          { "progress" },
        },

        -- nothing in Y
        lualine_y = {},

        -- far right: branch name
        lualine_z = { "mode" },
      },
    })
  end,
}
