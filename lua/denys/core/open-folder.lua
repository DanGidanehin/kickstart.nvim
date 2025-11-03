-- lua/denys/core/open-folder.lua
local M = {}

local function trim(s)
  return (s or ""):gsub("%s+$", "")
end

-- macOS Finder folder picker
local function choose_folder_macos()
  local h = io.popen([[osascript -e 'POSIX path of (choose folder with prompt "Select a project folder")']])
  if not h then
    return nil
  end
  local out = h:read("*a") or ""
  h:close()
  out = trim(out)
  if out == "" then
    return nil
  end
  return out:gsub("/$", "") -- strip trailing slash
end

local function cd_to(path)
  vim.cmd("cd " .. vim.fn.fnameescape(path))
end

-- Ensure nvim-tree is available; return its API or nil
local function get_tree_api()
  local ok, api = pcall(require, "nvim-tree.api")
  if ok then
    return api
  end
  -- lazy-loaded? open once to load it, then try again
  pcall(vim.cmd, "NvimTreeOpen")
  ok, api = pcall(require, "nvim-tree.api")
  if ok then
    return api
  end
  return nil
end

local function fallback_netrw(path)
  vim.cmd("Ex " .. vim.fn.fnameescape(path))
  vim.notify("nvim-tree not found; opened netrw instead", vim.log.levels.WARN)
end

-- --- public ---------------------------------------------------------------

-- Keep this name so existing requires/keymaps work:
function M.open()
  local path
  if vim.fn.has("macunix") == 1 then
    path = choose_folder_macos()
  else
    -- Non-macOS fallback: prompt for a path
    vim.ui.input({ prompt = "Folder path: ", default = vim.fn.getcwd() }, function(input)
      path = input and trim(input) or nil
    end)
  end
  if not path or path == "" then
    return
  end

  cd_to(path)

  local api = get_tree_api()
  if not api then
    fallback_netrw(path)
    return
  end

  -- Use API so it works even when the tree is already open
  vim.schedule(function()
    api.tree.open()
    pcall(api.tree.change_root, path)
    -- You can focus the tree if you prefer:
    -- api.tree.focus()
  end)
end

return M
