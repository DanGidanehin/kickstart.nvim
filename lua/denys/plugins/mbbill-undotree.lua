return {
  "mbbill/undotree",
  config = function()
    -- Window layout
    vim.g.undotree_WindowLayout = 3
    vim.g.undotree_DiffAutoOpen = 0
    vim.g.undotree_HelpLine = 0
    vim.g.undotree_ShortFileDiff = 1

    -- Symbols
    vim.g.undotree_TreeNodeShape = "○"
    vim.g.undotree_TreeVertShape = "│"
    vim.g.undotree_TreeSplitShape = "─╯"
    vim.g.undotree_TreeReturnShape = "─╮"

    -- Colors
    local function set_undotree_colors()
      vim.api.nvim_set_hl(0, "UndotreeBranch", { fg = "#7aa2f7", bold = true })
      vim.api.nvim_set_hl(0, "UndotreeNode", { fg = "#65D1FF" })
      vim.api.nvim_set_hl(0, "UndotreeCurrent", { fg = "#65D1FF", bold = true })
      vim.api.nvim_set_hl(0, "UndotreeNext", { fg = "#7aa2f7" })
      vim.api.nvim_set_hl(0, "UndotreeTimestamp", { fg = "#565f89" })
      vim.api.nvim_set_hl(0, "UndotreeSaved", { fg = "#9ece6a", bold = true })
    end
    set_undotree_colors()
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = set_undotree_colors,
    })

    local function undotree_focus_or_open()
      local found_win = nil
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "undotree" then
          found_win = win
          break
        end
      end
      if found_win then
        vim.api.nvim_set_current_win(found_win)
      else
        vim.cmd("UndotreeShow")
        vim.cmd("UndotreeFocus")
      end
    end

    vim.keymap.set("n", "<leader>ut", undotree_focus_or_open, { desc = "Open/Focus Undotree" })
    vim.keymap.set("n", "<leader>ux", vim.cmd.UndotreeHide, { desc = "Close Undotree" })
  end,
}
