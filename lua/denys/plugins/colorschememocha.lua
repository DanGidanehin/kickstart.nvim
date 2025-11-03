-- lua/denys/plugins/colorscheme.lua
return {
  "catppuccin/nvim",
  enabled = false,
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function()
    local ok, catppuccin = pcall(require, "catppuccin")
    if not ok then
      return
    end

    catppuccin.setup({
      flavour = "mocha", -- use mocha variant
      transparent_background = true, -- keep your terminal’s dark bg visible
      custom_highlights = function(c)
        local p = c.mocha or c
        local border = "#1a1b24" -- darkest border
        return {
          normal = { bg = "none" },
          normalfloat = { bg = "none" },
          floatborder = { fg = border, bg = "none" },
          winseparator = { fg = border, bg = "none" },
          vertsplit = { fg = border, bg = "none" },

          -- keep line numbers soft
          linenr = { fg = p.overlay0 },
          cursorlinenr = { fg = p.text },

          -- minimal cursorline
          cursorline = { bg = p.base },
          visual = { bg = p.surface0 },
        }
      end,
    })

    vim.opt.fillchars:append({ vert = "│", eob = " " }) -- clean splits & remove tildes
    vim.cmd.colorscheme("catppuccin")
  end,
}
