return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")
    local api = require("nvim-tree.api")
    local keymap = vim.keymap
    -- Disable netrw (recommended)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- Custom keybindings for nvim-tree buffer
    local function on_attach(bufnr)
      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- 📂 Navigation
      keymap.set("n", "<CR>", api.node.open.edit, opts("Open File or Folder"))
      keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Folder"))

      -- 🔼 Go up one directory
      keymap.set("n", "-", api.tree.change_root_to_parent, opts("Go Up One Directory"))

      -- 🔽 Go down one folder (focus as new root)
      keymap.set("n", "<Tab>", api.tree.change_root_to_node, opts("Focus Folder as Root (Tab)"))

      -- 🗂️ File actions
      keymap.set("n", "R", api.tree.reload, opts("Refresh"))
      keymap.set("n", "a", api.fs.create, opts("Create File"))
      keymap.set("n", "d", api.fs.remove, opts("Delete"))
      keymap.set("n", "r", api.fs.rename, opts("Rename"))
      keymap.set("n", "y", api.fs.copy.node, opts("Copy"))
      keymap.set("n", "p", api.fs.paste, opts("Paste"))
    end

    -- Main setup
    nvimtree.setup({
      on_attach = on_attach,
      view = {
        width = 48,
        relativenumber = true,
      },
      renderer = {
        indent_markers = { enable = true },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "",
              arrow_open = "",
            },
          },
        },
        root_folder_label = function(path)
          return vim.fn.fnamemodify(path, ":t")
        end,
      },
      actions = {
        open_file = {
          window_picker = { enable = false },
          quit_on_open = false,
        },
      },
      filters = {
        custom = { ".DS_Store" },
      },
      git = {
        enable = false,
        ignore = false,
      },
    })

    -- 🌍 Global keymaps (outside of tree buffer)
    local keymap = vim.keymap

    -- Open or focus NvimTree
    keymap.set("n", "<leader>ee", function()
      local api = require("nvim-tree.api")
      if not api.tree.is_visible() then
        api.tree.open()
      else
        api.tree.focus()
      end
    end, { desc = "Open or focus file explorer" })

    keymap.set("n", "<leader>eo", function()
      local api = require("nvim-tree.api")
      if api.tree.is_visible() then
        return
      end
      local cur_win = vim.api.nvim_get_current_win()
      api.tree.open()
      vim.api.nvim_set_current_win(cur_win)
    end, { desc = "Open Nvim-Tree without focusing" })

    keymap.set("n", "<leader>ex", "<cmd>NvimTreeToggle<CR>", { desc = "Close file explorer" })

    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" })
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })

    -- 🪟 Optional: open splits with tree open
    keymap.set("n", "sv", ":NvimTreeOpen<CR><C-w>v", { noremap = true, silent = true })
    keymap.set("n", "sh", ":NvimTreeOpen<CR><C-w>s", { noremap = true, silent = true })
  end,
}

-- return {
--   "nvim-tree/nvim-tree.lua",
--   dependencies = "nvim-tree/nvim-web-devicons",
--   config = function()
--     local nvimtree = require("nvim-tree")
--
--     -- recommended settings from nvim-tree documentation
--     vim.g.loaded_netrw = 1
--     vim.g.loaded_netrwPlugin = 1
--
--     nvimtree.setup({
--       view = {
--         width = 28,
--         relativenumber = true,
--       },
--       -- change folder arrow icons
--       renderer = {
--         indent_markers = {
--           enable = true,
--         },
--         icons = {
--           glyphs = {
--             folder = {
--               arrow_closed = "", -- arrow when folder is closed
--               arrow_open = "", -- arrow when folder is open
--             },
--           },
--         },
--       },
--       -- disable window_picker for
--       -- explorer to work well with
--       -- window splits
--       actions = {
--         open_file = {
--           window_picker = {
--             enable = false,
--           },
--         },
--       },
--       filters = {
--         custom = { ".DS_Store" },
--       },
--       git = {
--         enable = false,
--         ignore = false,
--       },
--     })
--
--     -- set keymaps
--     local keymap = vim.keymap -- for conciseness
--
--     keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
--     keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
--     keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
--     keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
--
--     -- custom keybindings to open split views on files
--     keymap.set("n", "sv", ":NvimTreeOpen<CR><C-w>v", { noremap = true, silent = true })
--     keymap.set("n", "sh", ":NvimTreeOpen<CR><C-w>s", { noremap = true, silent = true })
--   end,
-- }
