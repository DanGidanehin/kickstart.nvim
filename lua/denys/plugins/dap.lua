return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
      -- Language Adapters
      "leoluz/nvim-dap-go",
      "mfussenegger/nvim-dap-python",
      "mxsdev/nvim-dap-vscode-js",
    },
    config = function()
      local dap = require("dap")
      local ui = require("dapui")

      -- VISUALS: Red Dot Breakpoint & Icons
      -- Define Colors
      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e06c75" }) -- Red
      vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379" }) -- Green
      -- Define Signs
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpoint" })
      vim.fn.sign_define("DapStopped", { text = "➜", texthl = "DapStopped" })
      vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint" })

      -- SETUP UI & VIRTUAL TEXT
      require("dapui").setup()
      require("nvim-dap-virtual-text").setup({})

      -- LANGUAGE SETUP
      -- Go
      require("dap-go").setup()

      -- Python
      local python_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(python_path)

      -- JS / TS (Node, Chrome, etc.)
      require("dap-vscode-js").setup({
        -- Dummy values to satisfy the linter:
        node_path = "node",
        log_file_path = "(stdpath cache)/dap_vscode_js.log",
        log_file_level = 0,
        log_console_level = 0,
        -- Real configuration:
        debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
        debugger_cmd = { "js-debug-adapter" },
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
      })
      for _, language in ipairs({ "typescript", "javascript" }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end

      -- C / C++ / Rust (codelldb)
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      local codelldb_config = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
      dap.configurations.c = codelldb_config
      dap.configurations.cpp = codelldb_config
      dap.configurations.rust = codelldb_config

      -- C# (netcoredbg)
      dap.adapters.coreclr = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
          args = { "--interpreter=vscode" },
        },
      }
      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
          end,
        },
      }

      -- KEYMAPS
      local keymap = vim.keymap.set

      -- Breakpoints
      keymap("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      keymap("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Condition: "))
      end, { desc = "Conditional Breakpoint" })

      -- Stepping
      keymap("n", "<leader>dc", dap.continue, { desc = "Start/Continue Debugging" })
      keymap("n", "<leader>di", dap.step_into, { desc = "Step Into" })
      keymap("n", "<leader>do", dap.step_over, { desc = "Step Over" })
      keymap("n", "<leader>dO", dap.step_out, { desc = "Step Out" })
      keymap("n", "<leader>dr", dap.restart, { desc = "Restart Debug Session" })
      keymap("n", "<leader>dt", dap.terminate, { desc = "Terminate Debug Session" })

      -- UI Controls
      keymap("n", "<leader>du", ui.toggle, { desc = "Toggle Debug UI" })
      keymap("n", "<leader>de", function()
        ui.eval()
      end, { desc = "Evaluate Expression" })
      -- LISTENERS (Auto-Open UI)
      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
    end,
  },
}
