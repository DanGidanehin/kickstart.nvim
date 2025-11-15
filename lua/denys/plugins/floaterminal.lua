local state = {
  floating = { buf = -1, win = -1 },
  prev_win = -1,
}

-- Create (or reuse) a floating window for a given buffer
local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.95)
  local height = opts.height or math.floor(vim.o.lines * 0.33)

  -- your custom positioning
  local col = math.floor((vim.o.columns - width) / 2)
  local row = vim.o.lines - height - math.floor((vim.o.columns - width) / 4)

  local buf
  if opts.buf and vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- scratch/no-file
  end

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  })

  return { buf = buf, win = win }
end

-- Ensure buffer is a terminal; reuse the same terminal buffer across opens
local function ensure_terminal(buf)
  if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
    return buf
  end
  vim.cmd.terminal()
  return vim.api.nvim_get_current_buf()
end

-- Close ONLY the floating window (preserve buffer & terminal job)
local function close_floating_window()
  if state.floating.win ~= -1 and vim.api.nvim_win_is_valid(state.floating.win) then
    vim.api.nvim_win_close(state.floating.win, true)
    state.floating.win = -1
  end
end

-- Focus back to the window you had before opening the float
local function focus_previous_window()
  if state.prev_win ~= -1 and vim.api.nvim_win_is_valid(state.prev_win) then
    vim.api.nvim_set_current_win(state.prev_win)
  end
end

-- Buffer-local mappings for the floating terminal
local function set_float_mappings(buf)
  -- Esc (in terminal mode) → focus previous window (do not close or clear buffer)
  vim.keymap.set("t", "<esc>", function()
    focus_previous_window()
  end, { buffer = buf, nowait = true, silent = true, desc = "Focus previous window" })

  -- Optional: also allow in normal/insert if you switch modes inside the term
  vim.keymap.set("n", "<esc>", focus_previous_window, { buffer = buf, nowait = true, silent = true })
  vim.keymap.set("i", "<esc>", focus_previous_window, { buffer = buf, nowait = true, silent = true })

  -- Keep your close shortcut
  for _, mode in ipairs({ "t", "i", "n" }) do
    vim.keymap.set(
      mode,
      "<C-x>",
      close_floating_window,
      { buffer = buf, nowait = true, silent = true, desc = "Close floating terminal window" }
    )
  end
end

-- Open or focus existing terminal window (remember previous win for <Esc>)
local function open_or_focus_terminal()
  -- remember where to return on <Esc> before focusing/opening the float
  state.prev_win = vim.api.nvim_get_current_win()

  if state.floating.win ~= -1 and vim.api.nvim_win_is_valid(state.floating.win) then
    vim.api.nvim_set_current_win(state.floating.win)
    vim.cmd("startinsert")
    return
  end

  -- (Re)create window, reusing previous buffer if it exists
  state.floating = create_floating_window({ buf = state.floating.buf })

  -- Make sure buffer is a terminal (reuse same job if possible)
  state.floating.buf = ensure_terminal(state.floating.buf)

  -- Attach buffer-local mappings
  set_float_mappings(state.floating.buf)

  -- Enter terminal/insert mode
  vim.cmd("startinsert")
end

-- :Floaterminal command and keybindings
vim.api.nvim_create_user_command("Floaterminal", open_or_focus_terminal, {})
vim.keymap.set("n", "<C-n>", "<cmd>Floaterminal<cr>", { desc = "Open or focus floating terminal", silent = true })
vim.keymap.set("n", "<C-x>", close_floating_window, { desc = "Close floating terminal window", silent = true })

-- Valid empty spec for lazy.nvim
return {}
