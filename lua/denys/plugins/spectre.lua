return {
  "nvim-pack/nvim-spectre",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local spectre = require("spectre")
    local state = {
      win = -1,
      has_path = false,
      prev_win = -1, -- remember where to return on <Esc>
    }

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

    -- Go back to window we had before opening Spectre
    local function focus_previous_window()
      if state.prev_win ~= -1 and vim.api.nvim_win_is_valid(state.prev_win) then
        vim.api.nvim_set_current_win(state.prev_win)
      end
    end

    -- Setup Spectre with floating window
    spectre.setup({
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
      -- remember where we were before jumping into Spectre
      state.prev_win = vim.api.nvim_get_current_win()

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
      -- also remember previous window when opening Spectre in file mode
      state.prev_win = vim.api.nvim_get_current_win()

      local filepath = get_valid_file()
      close_spectre()

      if filepath then
        local relative_path = vim.fn.fnamemodify(filepath, ":~:.")
        if not relative_path:match("^/") then
          relative_path = "/" .. relative_path
        end
        spectre.open({
          select_word = false,
          path = relative_path,
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
      -- same: remember where to return to
      state.prev_win = vim.api.nvim_get_current_win()

      close_spectre()
      spectre.open({ select_word = false })
      state.has_path = false
      enter_insert()
    end

    -- When Spectre panel is opened, map <Esc> to "unfocus" back
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "spectre_panel",
      callback = function(args)
        local buf = args.buf
        -- From NORMAL mode: <Esc> → go back to the previous window
        vim.keymap.set("n", "<esc>", function()
          focus_previous_window()
        end, { buffer = buf, nowait = true, silent = true, desc = "Focus previous window from Spectre" })
        -- From INSERT you'll do: Esc (leave insert), Esc (this mapping)
      end,
    })

    -- Keymaps
    vim.keymap.set({ "n", "v", "i" }, "<C-f>", open_or_focus, {
      desc = "Open/focus Spectre",
    })
    vim.keymap.set("n", "<leader>sf", search_in_file, { desc = "Search in current file" })
    vim.keymap.set("n", "<leader>qf", clear_path, { desc = "Clear path (global search)" })
    vim.keymap.set("n", "<leader>qs", close_spectre, { desc = "Close Spectre" })
    vim.keymap.set("n", "<leader>ic", function()
      spectre.change_options("ignore-case")
    end, { desc = "Toggle ignore case" })
  end,
}
