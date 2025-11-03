-- Make sure Neovim/Mason can find cargo and Homebrew bins
local home = vim.env.HOME
vim.env.PATH = table.concat({
  home .. "/.cargo/bin",
  "/opt/homebrew/bin",
  "/usr/local/bin",
  vim.env.PATH or "",
}, ":")

require("denys.core.options")
require("denys.core.keymaps")
require("denys.core.open-folder")
