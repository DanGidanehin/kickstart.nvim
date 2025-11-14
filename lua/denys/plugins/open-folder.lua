-- lua/denys/plugins/open-folder.lua
-- Single-file utility + Lazy-safe stub
local M = {}

-- HELPERS
local function rtrim_spaces(s)
  return (s or ""):gsub("%s+$", "")
end
local function normalize_path(p)
  if not p or p == "" then
    return nil
  end
  p = rtrim_spaces(p)
  if p == "" then
    return nil
  end
  return p:gsub("/$", "")
end
local function chdir(path)
  vim.cmd("cd " .. vim.fn.fnameescape(path))
end

-- MacOS folder picker
local function pick_folder_macos()
  local h = io.popen([[osascript -e 'POSIX path of (choose folder with prompt "Select a project folder")']])
  if not h then
    return nil
  end
  local out = h:read("*a") or ""
  h:close()
  return normalize_path(out)
end

-- nvim-tree api loader
local function get_nvimtree_api()
  local ok, api = pcall(require, "nvim-tree.api")
  if ok then
    return api
  end
  pcall(function()
    vim.cmd("NvimTreeOpen")
  end)
  ok, api = pcall(require, "nvim-tree.api")
  if ok then
    return api
  end
  return nil
end

local function open_with_netrw(path)
  vim.cmd("Ex " .. vim.fn.fnameescape(path))
  vim.notify("nvim-tree not found; opened netrw instead", vim.log.levels.WARN)
end

local function open_in_tree(path)
  if not path then
    return
  end
  chdir(path)
  local api = get_nvimtree_api()
  if not api then
    open_with_netrw(path)
    return
  end
  vim.schedule(function()
    api.tree.open()
    pcall(function()
      api.tree.change_root(path)
    end)
  end)
end

function M.open()
  if vim.fn.has("macunix") == 1 then
    open_in_tree(pick_folder_macos())
    return
  end
  vim.ui.input({ prompt = "Folder path: ", default = vim.fn.getcwd() }, function(input)
    open_in_tree(normalize_path(input))
  end)
end

-- Publish the module
package.loaded["denys.open_folder"] = M

-- KEYMAPS
-- Open Folder using Finder picker
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    vim.keymap.set("n", "<leader>of", function()
      require("denys.open_folder").open()
    end, { desc = "Open project folder in NvimTree" })
  end,
})

-- Return an empty plugin spec so Lazy won't try to load this file
return {}
