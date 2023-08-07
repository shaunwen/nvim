local status, saga = pcall(require, "lspsaga")
if (not status) then return end

saga.setup({
  ui = {
    border = 'rounded',
    colors = {
      normal_bg = '#282828',
      purple = '#61AFEF', -- use blue for finder type
      magenta = '#F7BB3B' -- use yellow for loading
    }
  },
  finder = {
    default = 'ref+imp+def',
    keys = {
      quit = 'q',
      toggle_or_open = '<CR>',
      vsplit = 's',
      split = 'i',
      shuttle = '[w',
      close = '<C-c>k'
    },
  },
  outline = {
    auto_preview = false,
    keys = {
      toggle_or_jump = '<CR>'
    }
  }
})

local opts = { noremap = true, silent = true }
vim.keymap.set('n', 'K', '<Cmd>Lspsaga hover_doc<CR>', opts)
vim.keymap.set('n', 'gd', '<Cmd>Lspsaga finder<CR>', opts)
vim.keymap.set('n', 'gp', '<Cmd>Lspsaga peek_definition<CR>', opts)
vim.keymap.set('n', 'gr', '<Cmd>Lspsaga rename<CR>', opts)
vim.keymap.set({ 'n', 'v' }, '<leader>ca', '<cmd>Lspsaga code_action<CR>', opts)
vim.keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
vim.keymap.set('n', ']e', '<cmd>Lspsaga diagnostic_jump_next<CR>', opts)
vim.keymap.set('n', '<leader>o', '<cmd>Lspsaga outline<CR>', opts)
vim.keymap.set("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
vim.keymap.set("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")

vim.cmd('highlight LspDiagnosticsFloatingError guifg=green')
