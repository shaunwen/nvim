local M = {}
local terminals = {}

local function get_terminal(name, opts)
  local Terminal = require('toggleterm.terminal').Terminal
  if not terminals[name] then
    terminals[name] = Terminal:new(vim.tbl_extend('force', { hidden = true }, opts))
  end
  return terminals[name]
end

function M.setup()
  local status_ok, toggleterm = pcall(require, 'toggleterm')
  if not status_ok then
    return
  end

  toggleterm.setup({
    size = 20,
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = false,
    persist_size = true,
    direction = 'float',
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = 'curved',
      winblend = 0,
      highlights = {
        border = 'Normal',
        background = 'Normal',
      },
    },
  })

  local term_group = vim.api.nvim_create_augroup('ToggleTermKeymaps', { clear = true })
  vim.api.nvim_create_autocmd('TermOpen', {
    group = term_group,
    pattern = 'term://*',
    callback = function()
      local opts = { noremap = true }
      vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
      vim.api.nvim_buf_set_keymap(0, 't', ',h', [[<C-\><C-n><C-W>h]], opts)
      vim.api.nvim_buf_set_keymap(0, 't', ',j', [[<C-\><C-n><C-W>j]], opts)
      vim.api.nvim_buf_set_keymap(0, 't', ',k', [[<C-\><C-n><C-W>k]], opts)
      vim.api.nvim_buf_set_keymap(0, 't', ',l', [[<C-\><C-n><C-W>l]], opts)
    end,
  })
end

function M.toggle_float()
  get_terminal('float', { direction = 'float' }):toggle()
end

function M.toggle_gitui()
  get_terminal('gitui', { cmd = 'gitui' }):toggle()
end

function M.toggle_python()
  get_terminal('python', { cmd = 'python' }):toggle()
end

function M.toggle_horizontal()
  get_terminal('horizontal', { direction = 'horizontal', size = 30 }):toggle()
end

function M.toggle_vertical()
  get_terminal('vertical', { direction = 'vertical', size = 60 }):toggle()
end

return M
