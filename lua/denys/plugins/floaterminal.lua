local state = {
  floating = { buf = -1, win = -1 },
  prev_win = -1,
}

-- Helper: Create the floating window
local function create_floating_window(opts)
  opts = opts or {}

  local total_cols = vim.o.columns
  local total_lines = vim.o.lines
  local padding = 6

  local width = opts.width or (total_cols + 2 - 2 * padding)
  local height = opts.height or math.floor(total_lines * 0.30)

  local col = total_cols - width - padding
  local row = total_lines - height + 2

  local buf
  if opts.buf and vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
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

-- Helper: Ensure buffer is a terminal
local function ensure_terminal(buf)
  if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
    return buf
  end
  vim.cmd.terminal()
  return vim.api.nvim_get_current_buf()
end

-- Action: Close Window (Hide)
local function close_floating_window()
  if state.floating.win ~= -1 and vim.api.nvim_win_is_valid(state.floating.win) then
    vim.api.nvim_win_close(state.floating.win, true)
    state.floating.win = -1
  end
end

-- Action: Focus Previous Window
local function focus_previous_window()
  if state.prev_win ~= -1 and vim.api.nvim_win_is_valid(state.prev_win) then
    vim.api.nvim_set_current_win(state.prev_win)
  end
end

-- Action: Kill Terminal
local function clear_terminal()
  if state.floating.win ~= -1 and vim.api.nvim_win_is_valid(state.floating.win) then
    vim.api.nvim_win_close(state.floating.win, true)
    state.floating.win = -1
  end

  if state.floating.buf ~= -1 and vim.api.nvim_buf_is_valid(state.floating.buf) then
    vim.api.nvim_buf_delete(state.floating.buf, { force = true })
  end

  state.floating.buf = -1
end

-- Setup Buffer Mappings
local function set_float_mappings(buf)
  vim.keymap.set("t", "<esc>", focus_previous_window, { buffer = buf, nowait = true, silent = true })
  vim.keymap.set("t", "<C-q>", close_floating_window, { buffer = buf, nowait = true, silent = true })
end

-- Main Function: Open or Focus
local function open_or_focus_terminal()
  state.prev_win = vim.api.nvim_get_current_win()

  if state.floating.win ~= -1 and vim.api.nvim_win_is_valid(state.floating.win) then
    vim.api.nvim_set_current_win(state.floating.win)
    vim.cmd("startinsert")
    return
  end

  state.floating = create_floating_window({ buf = state.floating.buf })
  state.floating.buf = ensure_terminal(state.floating.buf)
  set_float_mappings(state.floating.buf)
  vim.cmd("startinsert")
end

-- Action: Reset (Clear + Reopen)
local function reset_terminal()
  clear_terminal() -- Kill the buffer
  open_or_focus_terminal() -- Open a new one immediately
  print("Terminal Reset!")
end

-- KEYMAPS
vim.api.nvim_create_user_command("Floaterminal", open_or_focus_terminal, {})
vim.api.nvim_create_user_command("ClearTerminal", clear_terminal, {})

-- Open or focus existing terminal window
vim.keymap.set(
  { "n", "v", "i", "t" },
  "<C-t>",
  open_or_focus_terminal,
  { desc = "Toggle floating terminal", silent = true }
)

-- Close terminal window
vim.keymap.set({ "n", "v", "i", "t" }, "<C-q>", close_floating_window, { desc = "Hide terminal window", silent = true })

-- Clear current terminal buffer
vim.keymap.set({ "n", "v", "i", "t" }, "<C-x>", reset_terminal, { desc = "Reset floating terminal", silent = true })

return {}
