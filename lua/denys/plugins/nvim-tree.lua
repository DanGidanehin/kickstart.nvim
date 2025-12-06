return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")
    local api = require("nvim-tree.api")
    local keymap = vim.keymap

    -- Standard on_attach function
    local function on_attach(bufnr)
      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- Navigation
      keymap.set("n", "<CR>", api.node.open.edit, opts("Open File or Folder"))
      keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Folder"))
      keymap.set("n", "<S-Tab>", api.tree.change_root_to_parent, opts("Go Up One Directory"))
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
          glyphs = { folder = { arrow_closed = "", arrow_open = "" } },
        },
        root_folder_label = function(path)
          return vim.fn.fnamemodify(path, ":t")
        end,
      },
      actions = {
        open_file = { window_picker = { enable = false }, quit_on_open = true },
      },
      filters = { custom = { ".DS_Store" } },
      git = { enable = false, ignore = false },
    })

    -- SHORTCUTS
    keymap.set("n", "<leader>ee", function()
      api.tree.find_file({ open = true, focus = true })
    end, { desc = "Focus explorer on current file" })

    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
    keymap.set("n", "<leader>ex", "<cmd>NvimTreeToggle<CR>", { desc = "Close file explorer" })

    keymap.set("n", "<C-n>", function()
      local current_buf = vim.api.nvim_buf_get_name(0)
      local base_path

      if current_buf == "" then
        base_path = vim.fn.getcwd()
      else
        base_path = vim.fn.fnamemodify(current_buf, ":h")
      end

      api.tree.find_file({ open = true, focus = true })

      vim.ui.input({
        prompt = "Create file in " .. vim.fn.fnamemodify(base_path, ":t") .. "/: ",
        completion = "file",
      }, function(input)
        if not input or input == "" then
          return
        end

        local new_file_path = base_path .. "/" .. input

        if input:sub(-1) == "/" then
          vim.fn.mkdir(new_file_path, "p")
          api.tree.reload()
        else
          local file = io.open(new_file_path, "r")
          if file then
            file:close()
            vim.notify("File already exists", vim.log.levels.WARN)
          else
            file = io.open(new_file_path, "w")
            if file then
              file:close()
              vim.cmd("edit " .. vim.fn.fnameescape(new_file_path))
              api.tree.find_file({ open = true, focus = true })
            else
              vim.notify("Could not create file", vim.log.levels.ERROR)
            end
          end
        end
      end)
    end, { desc = "Create new file in current folder" })
  end,
}
