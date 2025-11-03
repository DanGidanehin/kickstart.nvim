return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- Get parser/stream from the builtin eslint_d (function or table), if available
    local base = lint.linters.eslint_d
    local ok, built = pcall(function()
      if type(base) == "function" then
        return base() -- some versions export a factory
      end
      return base -- table or nil
    end)

    local parser = (ok and built and built.parser) or require("lint.parser").from_eslint() -- fallback parser
    local stream = (ok and built and built.stream) or "both"

    -- Our robust custom linter that supports ESLint v9 flat config + global fallback
    lint.linters.eslint_d_custom = {
      cmd = "eslint_d",
      stdin = true,
      ignore_exitcode = true,
      stream = stream,
      parser = parser,
      args = function()
        local buf = vim.api.nvim_get_current_buf()
        local fname = vim.api.nvim_buf_get_name(buf)
        local dir = vim.fs.dirname(fname)

        -- Prefer project flat config
        local cfg = vim.fs.find({
          "eslint.config.js",
          "eslint.config.cjs",
          "eslint.config.mjs",
          "eslint.config.ts",
        }, { upward = true, path = dir })[1]

        local args = { "--stdin", "--stdin-filename", fname }
        if not cfg then
          -- Fall back to your global flat config
          table.insert(args, "--config")
          table.insert(args, vim.fn.expand(vim.env.ESLINT_CONFIG_PATH or "~/.config/eslint/eslint.config.mjs"))
        end
        return args
      end,
    }

    -- Use ONLY our custom linter to avoid indexing the builtin function
    lint.linters_by_ft = {
      javascript = { "eslint_d_custom" },
      typescript = { "eslint_d_custom" },
      javascriptreact = { "eslint_d_custom" },
      typescriptreact = { "eslint_d_custom" },
      svelte = { "eslint_d_custom" },
      python = { "pylint" },
    }

    -- Auto-lint
    local grp = vim.api.nvim_create_augroup("lint", { clear = true })
    local function try_linting()
      local linters = lint.linters_by_ft[vim.bo.filetype]
      if linters then
        lint.try_lint(linters)
      end
    end

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = grp,
      callback = try_linting,
    })

    -- Manual trigger
    vim.keymap.set("n", "<leader>l", try_linting, { desc = "Trigger linting for current file" })
  end,
}

-- return {
--   "mfussenegger/nvim-lint",
--   event = { "BufReadPre", "BufNewFile" },
--   config = function()
--     local lint = require("lint")
--
--     lint.linters_by_ft = {
--       javascript = { "eslint_d" },
--       typescript = { "eslint_d" },
--       javascriptreact = { "eslint_d" },
--       typescriptreact = { "eslint_d" },
--       svelte = { "eslint_d" },
--       python = { "pylint" },
--     }
--
--     local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
--
--     local function file_in_cwd(file_name)
--       return vim.fs.find(file_name, {
--         upward = true,
--         stop = vim.loop.cwd():match("(.+)/"),
--         path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
--         type = "file",
--       })[1]
--     end
--
--     local function remove_linter(linters, linter_name)
--       for k, v in pairs(linters) do
--         if v == linter_name then
--           linters[k] = nil
--           break
--         end
--       end
--     end
--
--     local function linter_in_linters(linters, linter_name)
--       for k, v in pairs(linters) do
--         if v == linter_name then
--           return true
--         end
--       end
--       return false
--     end
--
--     local function remove_linter_if_missing_config_file(linters, linter_name, config_file_name)
--       if linter_in_linters(linters, linter_name) and not file_in_cwd(config_file_name) then
--         remove_linter(linters, linter_name)
--       end
--     end
--
--     local function try_linting()
--       local linters = lint.linters_by_ft[vim.bo.filetype]
--
--       -- if linters then
--       --   -- remove_linter_if_missing_config_file(linters, "eslint_d", ".eslintrc.cjs")
--       --   remove_linter_if_missing_config_file(linters, "eslint_d", "eslint.config.js")
--       -- end
--
--       lint.try_lint(linters)
--     end
--
--     vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
--       group = lint_augroup,
--       callback = function()
--         try_linting()
--       end,
--     })
--
--     vim.keymap.set("n", "<leader>l", function()
--       try_linting()
--     end, { desc = "Trigger linting for current file" })
--   end,
-- }
