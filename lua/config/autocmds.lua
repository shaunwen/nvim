local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- :restart sources its session from inside an autocommand, where lazy.nvim replaying
-- FileType for BufReadPre-loaded plugins makes the core :setf skip every restored buffer.
vim.api.nvim_create_autocmd('SessionLoadPost', {
  group = vim.api.nvim_create_augroup('SessionFiletypeRedetect', { clear = true }),
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if
        vim.api.nvim_buf_is_loaded(buf)
        and vim.bo[buf].buftype == ''
        and vim.bo[buf].filetype == ''
      then
        local ft = vim.filetype.match({ buf = buf })
        if ft then
          vim.bo[buf].filetype = ft
        end
      end
    end
  end,
})
