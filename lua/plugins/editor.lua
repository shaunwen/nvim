local function open_current_file()
  local bufname = vim.api.nvim_buf_get_name(0)
  local path = vim.fn.fnamemodify(bufname, ':p')

  if path and vim.uv.fs_stat(path) then
    require('mini.files').open(bufname, false)
  end
end

return {
  { 'tpope/vim-surround', lazy = false },
  { 'terryma/vim-multiple-cursors', lazy = false },
  {
    'tpope/vim-sleuth',
    event = { 'BufReadPre', 'BufNewFile' },
  },
  {
    'echasnovski/mini.files',
    version = '*',
    keys = {
      { '<leader>e', open_current_file, desc = 'Open Mini Files at current file' },
    },
    config = function()
      require('config.plugins.mini')
    end,
  },
  { 'tpope/vim-abolish', lazy = false },
}
