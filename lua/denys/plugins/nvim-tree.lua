return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")
    local api = require("nvim-tree.api")
    local keymap = vim.keymap

    -- This function is defining custom keybindings for nvim-tree window
    local function on_attach(bufnr)
      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- Navigation
      keymap.set("n", "<CR>", api.node.open.edit, opts("Open File or Folder"))
      keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Folder"))

      -- Go up one folder
      keymap.set("n", "<S-Tab>", api.tree.change_root_to_parent, opts("Go Up One Directory"))
      -- Focus folder as new root
      keymap.set("n", "<Tab>", api.tree.change_root_to_node, opts("Focus Folder as Root"))

      keymap.set("n", "R", api.tree.reload, opts("Refresh"))
      keymap.set("n", "a", api.fs.create, opts("Create File"))
      keymap.set("n", "d", api.fs.remove, opts("Delete"))
      keymap.set("n", "r", api.fs.rename, opts("Rename"))
      keymap.set("n", "y", api.fs.copy.node, opts("Copy"))
      keymap.set("n", "p", api.fs.paste, opts("Paste"))
    end

    -- MAIN CONFIG
    nvimtree.setup({
      on_attach = on_attach,
      view = {
        width = 32,
        number = false,
        relativenumber = false,
      },
      renderer = {
        indent_markers = { enable = true },
        icons = {
          glyphs = {
            folder = {
              -- arrow_closed = "",
              -- arrow_open = "",
              -- arrow_closed = "",
              -- arrow_open   = "",
              arrow_closed = "",
              arrow_open = "",
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
          quit_on_open = true,
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

    -- SHORTCUTS
    -- Open or focus nvim-tree
    keymap.set("n", "<leader>ee", function()
      if not api.tree.is_visible() then
        api.tree.open()
      else
        api.tree.focus()
      end
    end, { desc = "Open or focus file explorer" })

    -- Open nvim-tree without focusing on it
    keymap.set("n", "<leader>eo", function()
      if api.tree.is_visible() then
        return
      end
      local cur_win = vim.api.nvim_get_current_win()
      api.tree.open()
      vim.api.nvim_set_current_win(cur_win)
    end, { desc = "Open Nvim-Tree without focusing" })

    -- Other
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" })
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
    keymap.set("n", "<leader>ex", "<cmd>NvimTreeToggle<CR>", { desc = "Close file explorer" })
  end,
}
