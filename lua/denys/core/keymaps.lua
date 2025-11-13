vim.g.mapleader = " "

local keymap = vim.keymap

-- ===== Toggle soft wrap =====
local function toggle_wrap()
  local was = vim.wo.wrap
  vim.wo.wrap = not was
  vim.wo.linebreak = vim.wo.wrap -- break at word boundaries
  vim.wo.breakindent = vim.wo.wrap -- keep indentation when wrapped
  vim.opt.showbreak = vim.wo.wrap and "↪ " or "" -- visual mark for wrapped lines
  vim.notify("Wrap: " .. (vim.wo.wrap and "ON" or "OFF"), vim.log.levels.INFO)
end
keymap.set({ "n", "v" }, "<leader>tw", toggle_wrap, { desc = "Toggle wrap (linebreak/breakindent)" })

-- Restart Neovim (reload config)
keymap.set("n", "<leader>qr", "<cmd>source $MYVIMRC<CR>", { desc = "Reload Neovim config" })

-- Open folder in Finder
keymap.set("n", "<leader>of", function()
  require("denys.core.open-folder").open()
end, { desc = "Open project folder in NvimTree" })
-- keymap.set("n", "<leader>of", function()
--   require("denys.core.open-folder").open()
-- end, { desc = "Open folder (Finder) in NvimTree" })

-- Copy / select / paste whole file
keymap.set("n", "<leader>ya", ":%y+<CR>", { desc = "Yank entire buffer to clipboard" })
keymap.set("n", "<leader>va", "ggVG", { desc = "Select entire buffer" })
keymap.set("n", "<leader>pa", 'ggVG"+p', { desc = "Paste clipboard over entire buffer" })

-- Clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- ===== Window management =====
keymap.set("n", "<leader>sv", function()
  vim.cmd("vsplit") -- open vertical split
  require("nvim-tree.api").tree.open() -- open NvimTree in it
end, { desc = "Vertical split + open NvimTree" })

keymap.set("n", "<leader>sh", function()
  vim.cmd("split") -- open horizontal split
  require("nvim-tree.api").tree.open() -- open NvimTree in it
end, { desc = "Horizontal split + open NvimTree" })

keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })
keymap.set("n", "<leader>tr", ":tabnew #<CR>", { desc = "Reopen last closed tab" })

-- Resize windows
keymap.set("n", "<leader>hh", "<cmd>vertical resize +5<CR>", { desc = "Resize window left" })
keymap.set("n", "<leader>ll", "<cmd>vertical resize -5<CR>", { desc = "Resize window right" })
keymap.set("n", "<leader>kk", "<cmd>resize +5<CR>", { desc = "Resize window up" })
keymap.set("n", "<leader>jj", "<cmd>resize -5<CR>", { desc = "Resize window down" })

-- ===== Tabs navigation (tmux-like repeat) =====

-- ===== Direct tab jumps: <leader>t1..t9 go to N, <leader>t0 go to last =====
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

-- (Optional) keep your existing helpers:
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>to", function()
  vim.cmd("tabnew")
  vim.cmd("NvimTreeToggle")
end, { desc = "Open new tab with NvimTree" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- -- ===== Tabs navigation (tmux-like repeat) =====
-- local TAB_MODE = { active = false, timer = nil, timeout = 3000 } -- ms
--
-- local function _start_timer()
--   local uv = vim.uv or vim.loop
--   if TAB_MODE.timer then
--     TAB_MODE.timer:stop()
--     TAB_MODE.timer:close()
--     TAB_MODE.timer = nil
--   end
--   TAB_MODE.timer = uv.new_timer()
--   TAB_MODE.timer:start(TAB_MODE.timeout, 0, function()
--     vim.schedule(function()
--       if TAB_MODE.active then
--         vim.notify("🔵 Tab mode: timed out", vim.log.levels.INFO)
--         vim.cmd("normal! <Esc>") -- ensure normal-mode cleanup visual
--         -- exit_tab_mode() below handles actual cleanup
--       end
--       -- call after schedule to avoid race with keymaps
--       if TAB_MODE.active then
--         -- exit only once
--         local ok, exit = pcall(vim.api.nvim_get_var, "__tab_mode_exit_fn")
--         if ok and type(exit) == "function" then
--           exit()
--         end
--       end
--     end)
--   end)
-- end
--
-- local function exit_tab_mode()
--   if not TAB_MODE.active then
--     return
--   end
--   TAB_MODE.active = false
--   -- remove temporary keymaps
--   pcall(vim.keymap.del, "n", "n")
--   pcall(vim.keymap.del, "n", "p")
--   for i = 0, 9 do
--     pcall(vim.keymap.del, "n", tostring(i))
--   end
--   pcall(vim.keymap.del, "n", "<Esc>")
--
--   -- stop timer
--   if TAB_MODE.timer then
--     TAB_MODE.timer:stop()
--     TAB_MODE.timer:close()
--     TAB_MODE.timer = nil
--   end
--
--   -- clear stored exit fn
--   pcall(vim.api.nvim_del_var, "__tab_mode_exit_fn")
--
--   vim.notify("🔵 Tab mode: OFF", vim.log.levels.INFO)
-- end
--
-- local function enter_tab_mode()
--   if TAB_MODE.active then
--     return
--   end
--   TAB_MODE.active = true
--   vim.notify("⇥ Tab mode: ON  (n: next, p: prev, 1..9: goto, 0: last, Esc: exit, 3s timeout)", vim.log.levels.INFO)
--
--   -- store exit function so timer can call it safely
--   vim.api.nvim_set_var("__tab_mode_exit_fn", exit_tab_mode)
--
--   -- helpers
--   local function reset_and(f)
--     return function(...)
--       f(...)
--       _start_timer()
--     end
--   end
--
--   -- n → next, p → prev
--   keymap.set(
--     "n",
--     "n",
--     reset_and(function()
--       vim.cmd.tabnext()
--     end),
--     { silent = true, noremap = true, desc = "Tab mode: next" }
--   )
--   keymap.set(
--     "n",
--     "p",
--     reset_and(function()
--       vim.cmd.tabprevious()
--     end),
--     { silent = true, noremap = true, desc = "Tab mode: previous" }
--   )
--
--   -- 1..9 → goto tab; 0 → last tab
--   for i = 1, 9 do
--     keymap.set(
--       "n",
--       tostring(i),
--       reset_and(function()
--         vim.cmd("tabnext " .. i)
--       end),
--       { silent = true, noremap = true, desc = "Tab mode: goto " .. i }
--     )
--   end
--   keymap.set(
--     "n",
--     "0",
--     reset_and(function()
--       local last = vim.fn.tabpagenr("$")
--       vim.cmd("tabnext " .. last)
--     end),
--     { silent = true, noremap = true, desc = "Tab mode: last tab" }
--   )
--
--   -- Esc → exit mode
--   keymap.set("n", "<Esc>", exit_tab_mode, { silent = true, noremap = true, desc = "Exit Tab mode" })
--   _start_timer()
-- end
--
-- -- Enter Tab Mode
-- keymap.set("n", "<leader>tt", enter_tab_mode, { desc = "Enter Tab navigation mode" })
--
-- keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) -- go to next tab
-- keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) -- go to previous tab
-- keymap.set("n", "<leader>to", function()
--   vim.cmd("tabnew") -- open new tab
--   vim.cmd("NvimTreeToggle") -- open nvim-tree in it
-- end, { desc = "Open new tab with NvimTree" })
-- keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
-- keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- ===== Comment / Uncomment (ft-aware) =====
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

-- Normal mode
keymap.set("n", "<leader>kc", function()
  local l = vim.api.nvim_win_get_cursor(0)[1]
  _comment_lines(l, l)
end, { desc = "Comment current line (ft-aware)" })

keymap.set("n", "<leader>ku", function()
  local l = vim.api.nvim_win_get_cursor(0)[1]
  _uncomment_lines(l, l)
end, { desc = "Uncomment current line (ft-aware)" })

-- Visual mode
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
