local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
  return
end

toggleterm.setup({
  size = 20,
  open_mapping = [[<leader>tt]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = false,
  persist_size = true,
  direction = "float",
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    border = "curved",
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
})

function _G.set_terminal_keymaps()
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', ',h', [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', ',j', [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', ',k', [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', ',l', [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

local Terminal = require("toggleterm.terminal").Terminal

function _GITUI_TOGGLE()
  local gitui = Terminal:new({ cmd = "gitui", hidden = true })
  gitui:toggle()
end

function _PYTHON_TOGGLE()
  local python = Terminal:new({ cmd = "python", hidden = true })
  python:toggle()
end

function _HORIZONTAL_TOGGLE()
  local horizontal = Terminal:new({ direction = "horizontal", size = 30, hidden = true })
  horizontal:toggle()
end

function _VERTICAL_TOGGLE()
  local vertical = Terminal:new({ direction = "vertical", size = 60, hidden = true })
  vertical:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>ui", "<cmd>lua _GITUI_TOGGLE()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>py", "<cmd>lua _PYTHON_TOGGLE()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ts", "<cmd>lua _HORIZONTAL_TOGGLE()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>tv", "<cmd>lua _VERTICAL_TOGGLE()<CR>", { noremap = true, silent = true })
