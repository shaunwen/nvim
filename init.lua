vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('config.options')

if #vim.api.nvim_list_uis() > 0 then
  require('vim._core.ui2').enable()
end

require('config.lazy')
require('config.keymaps')
require('config.autocmds')
