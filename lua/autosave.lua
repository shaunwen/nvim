local bufnr = 50
vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
  "hello", "world"
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("Test", { clear = true }),
  pattern = 'autosave.lua',
  callback = function()
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "otuput of some file" })
  end,

  vim.fn.jobstart({ "go", "run", "main.go" }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
      end
    end,
  })
})
