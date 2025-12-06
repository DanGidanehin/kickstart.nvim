local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local uv = vim.uv

---@diagnostic disable-next-line: undefined-field
if not uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "denys.plugins" },
  { import = "denys.plugins.lsp" },
}, {
  checker = {
    enabled = true,
    notify = false,
  },
  ui = {
    border = "rounded",
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
})
