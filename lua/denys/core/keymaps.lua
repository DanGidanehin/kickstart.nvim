-- GENERAL SETTINGS
vim.g.mapleader = " "
local keymap = vim.keymap

-- GENERAL KEYMAPS
-- Reload nvim config
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
keymap.set({ "n", "v" }, "<leader>sv", vim.cmd.vsplit, { desc = "Vertical split" })
-- Split Horizontally
keymap.set({ "n", "v" }, "<leader>sh", vim.cmd.hsplit, { desc = "Horizontal split" })
-- Close current Window
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })
-- Resize windows
keymap.set("n", "<leader>hh", "<cmd>vertical resize +5<CR>", { desc = "Resize window left" })
keymap.set("n", "<leader>ll", "<cmd>vertical resize -5<CR>", { desc = "Resize window right" })
keymap.set("n", "<leader>kk", "<cmd>resize +5<CR>", { desc = "Resize window up" })
keymap.set("n", "<leader>jj", "<cmd>resize -5<CR>", { desc = "Resize window down" })
