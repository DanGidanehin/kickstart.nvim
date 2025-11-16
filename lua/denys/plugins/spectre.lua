return {
  "nvim-pack/nvim-spectre",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local spectre = require("spectre")
    local state = { win = -1, has_path = false }

    -- Create floating window for Spectre
    local function create_floating_window()
      local total_cols = vim.o.columns
      local total_lines = vim.o.lines

      local padding = 6

      -- Spectre window size
      local width = math.floor(total_cols * 0.30)
      local height = math.floor(total_lines * 0.30)

      -- Align right side using same padding
      local col = total_cols - width - padding
      local row = total_lines - height + 2

      local buf = vim.api.nvim_create_buf(false, true)
      state.win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal",
        border = "rounded",
      })
    end

    -- Close Spectre window
    local function close_spectre()
      if state.win ~= -1 and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_win_close(state.win, true)
        state.win = -1
        state.has_path = false
      end
    end

    -- Setup Spectre with floating window
    spectre.setup({
      default = {
        find = { cmd = "rg" },
        replace = { cmd = "sed" },
      },
      open_cmd = create_floating_window,
      replace_vim_cmd = "edit_no_buffer_check",
    })

    -- Enter insert mode
    local function enter_insert()
      vim.schedule(function()
        vim.cmd("startinsert")
      end)
    end

    -- Open or focus Spectre
    local function open_or_focus()
      if state.win ~= -1 and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_set_current_win(state.win)
      else
        spectre.open()
        state.has_path = false
        enter_insert()
      end
    end

    -- Get valid file (not terminal or nvim-tree)
    local function get_valid_file()
      local wins = vim.api.nvim_list_wins()
      for _, win in ipairs(wins) do
        if win ~= state.win and vim.api.nvim_win_is_valid(win) then
          local buf = vim.api.nvim_win_get_buf(win)
          local buftype = vim.bo[buf].buftype
          local filetype = vim.bo[buf].filetype
          local bufname = vim.api.nvim_buf_get_name(buf)

          if
            buftype ~= "terminal"
            and buftype ~= "nofile"
            and filetype ~= "NvimTree"
            and filetype ~= "spectre_panel"
            and not bufname:match("NvimTree_")
            and not bufname:match("term://")
            and bufname ~= ""
          then
            return bufname
          end
        end
      end
      return nil
    end

    -- Search in current file
    local function search_in_file()
      local filepath = get_valid_file()
      close_spectre()

      if filepath then
        spectre.open({
          select_word = false,
          path = vim.fn.fnamemodify(filepath, ":~:."),
        })
        state.has_path = true
      else
        spectre.open({ select_word = false })
        state.has_path = false
      end

      enter_insert()
    end

    -- Clear path (global search)
    local function clear_path()
      close_spectre()
      spectre.open({ select_word = false })
      state.has_path = false
      enter_insert()
    end

    -- Close or switch to global search
    local function smart_close()
      if state.win ~= -1 and vim.api.nvim_win_is_valid(state.win) then
        if state.has_path then
          clear_path()
        else
          close_spectre()
        end
      end
    end

    -- Keymaps
    vim.keymap.set("n", "<leader>sr", open_or_focus, { desc = "Open/focus Spectre" })
    vim.keymap.set("n", "<leader>sf", search_in_file, { desc = "Search in current file" })
    vim.keymap.set("n", "<leader>qf", clear_path, { desc = "Clear path (global search)" })
    vim.keymap.set("n", "<leader>qs", close_spectre, { desc = "Close Spectre" })
    vim.keymap.set("n", "<leader>ic", function()
      spectre.change_options("ignore-case")
    end, { desc = "Toggle ignore case" })
  end,
}
