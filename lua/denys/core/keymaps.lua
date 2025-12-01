-- GENERAL SETTINGS
vim.g.mapleader = " "
local keymap = vim.keymap

-- GENERAL KEYMAPS
-- Reload NVIM Config
keymap.set("n", "<leader>qr", "<cmd>source $MYVIMRC<CR>", { desc = "Reload Neovim config" })

-- Copy / Select / Paste whole file
keymap.set("n", "<leader>ya", ":%y+<CR>", { desc = "Yank entire buffer to clipboard" })
keymap.set("n", "<leader>va", "ggVG", { desc = "Select entire buffer" })
keymap.set("n", "<leader>pa", 'ggVG"+p', { desc = "Paste clipboard over entire buffer" })
-- Clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Open file in browser
vim.keymap.set("n", "<leader>oa", '<cmd>!open -a Arc "%"<cr>', { desc = "Open file in Arc" })

-- Toggle File Wrap
local function toggle_wrap()
  local was = vim.wo.wrap
  vim.wo.wrap = not was
  vim.wo.linebreak = vim.wo.wrap
  vim.wo.breakindent = vim.wo.wrap
  vim.opt.showbreak = vim.wo.wrap and "↪ " or ""
  vim.notify("Wrap: " .. (vim.wo.wrap and "ON" or "OFF"), vim.log.levels.INFO)
end
keymap.set({ "n", "v" }, "<leader>tw", toggle_wrap, { desc = "Toggle wrap (linebreak/breakindent)" })

-- WINDOW MANAGEMENT
-- Split Vertically
keymap.set("n", "<leader>sv", function()
  vim.cmd("vsplit")
  require("nvim-tree.api").tree.open()
end, { desc = "Vertical split + open NvimTree" })
-- Split Horizontally
keymap.set("n", "<leader>sh", function()
  vim.cmd("split")
  require("nvim-tree.api").tree.open()
end, { desc = "Horizontal split + open NvimTree" })

-- Helper Functions
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })
keymap.set("n", "<leader>tr", ":tabnew #<CR>", { desc = "Reopen last closed tab" })

-- Resize windows
keymap.set("n", "<leader>hh", "<cmd>vertical resize +5<CR>", { desc = "Resize window left" })
keymap.set("n", "<leader>ll", "<cmd>vertical resize -5<CR>", { desc = "Resize window right" })
keymap.set("n", "<leader>kk", "<cmd>resize +5<CR>", { desc = "Resize window up" })
keymap.set("n", "<leader>jj", "<cmd>resize -5<CR>", { desc = "Resize window down" })

-- TABS NAVIGATION
-- New Tab with opening nvim-tree
keymap.set("n", "<leader>to", function()
  vim.cmd("tabnew")
  vim.cmd("NvimTreeToggle")
end, { desc = "Open new tab with NvimTree" })
-- Open current buffer in new Tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
-- Close current Tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })

-- Tabs Navigation
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
-- Custom Function to jump to Tab using shortcuts
local function _goto_tab(n)
  local last = vim.fn.tabpagenr("$")
  if n == 0 then
    n = last
  end
  if n >= 1 and n <= last then
    vim.cmd("tabnext " .. n)
  else
    vim.notify("No tab " .. n, vim.log.levels.WARN)
  end
end
for i = 1, 9 do
  keymap.set("n", "<leader>t" .. i, function()
    _goto_tab(i)
  end, { silent = true, noremap = true, desc = "Go to tab " .. i })
end
keymap.set("n", "<leader>t0", function()
  _goto_tab(0)
end, { silent = true, noremap = true, desc = "Go to last tab" })

-- CUSTOM COMMENTS
local function _get_cs_parts()
  local cs = (vim.bo.commentstring ~= "" and vim.bo.commentstring) or "# %s"
  local s = cs:find("%%s", 1, true)
  if not s then
    return cs, ""
  end
  return cs:sub(1, s - 1), cs:sub(s + 2)
end

local function _escape_pat(s)
  return (s:gsub("([^%w])", "%%%1"))
end

local function _comment_lines(lstart, lend)
  local prefix, suffix = _get_cs_parts()
  for l = lstart, lend do
    local line = vim.api.nvim_buf_get_lines(0, l - 1, l, false)[1] or ""
    local indent = line:match("^(%s*)") or ""
    local rest = line:sub(#indent + 1)
    vim.api.nvim_buf_set_lines(0, l - 1, l, false, { indent .. prefix .. rest .. suffix })
  end
end

local function _uncomment_lines(lstart, lend)
  local prefix, suffix = _get_cs_parts()
  local preP, sufP = _escape_pat(prefix), _escape_pat(suffix)
  for l = lstart, lend do
    local line = vim.api.nvim_buf_get_lines(0, l - 1, l, false)[1] or ""
    if suffix ~= "" then
      line = line:gsub(sufP .. "%s*$", "")
    end
    if prefix ~= "" then
      local indent = line:match("^(%s*)") or ""
      local after = line:sub(#indent + 1):gsub("^" .. preP, "", 1)
      line = indent .. after
    end
    line = line:gsub("%s+$", "")
    vim.api.nvim_buf_set_lines(0, l - 1, l, false, { line })
  end
end

local function _visual_range()
  local l1, l2 = vim.fn.line("v"), vim.fn.line(".")
  if l1 > l2 then
    l1, l2 = l2, l1
  end
  return l1, l2
end

-- Normal Mode Comments
keymap.set("n", "<leader>kc", function()
  local l = vim.api.nvim_win_get_cursor(0)[1]
  _comment_lines(l, l)
end, { desc = "Comment current line (ft-aware)" })

keymap.set("n", "<leader>ku", function()
  local l = vim.api.nvim_win_get_cursor(0)[1]
  _uncomment_lines(l, l)
end, { desc = "Uncomment current line (ft-aware)" })

-- Visual Mode Comments
keymap.set("v", "<leader>kc", function()
  local l1, l2 = _visual_range()
  _comment_lines(l1, l2)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end, { desc = "Comment selection (ft-aware)" })

keymap.set("v", "<leader>ku", function()
  local l1, l2 = _visual_range()
  _uncomment_lines(l1, l2)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end, { desc = "Uncomment selection (ft-aware)" })
vim.g.mapleader = " "
