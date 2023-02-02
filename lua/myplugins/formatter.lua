local ok, formatter = pcall(require, "formatter")
if (not ok) then return end

local eslint_fmt = {
  function()
    return {
      exe = "./node_modules/.bin/eslint",
      args = { "--fix", "--stdin-filename", vim.api.nvim_buf_get_name(0) },
      stdin = false,
    }
  end
}

formatter.setup {
  logging = true,
  filetype = {
    -- typescript = eslint_fmt,
    -- typescriptreact = eslint_fmt,
    -- javascript = eslint_fmt,
    -- javascriptreact = eslint_fmt,
    python = {
      function()
        return {
          exe = '~/.pyenv/shims/black',
          args = { "-" },
          stdin = true,
        }
      end,
      function()
        return {
          exe = '~/.pyenv/shims/isort',
          args = { "-" },
          stdin = true,
        }
      end
    }
  }
}
