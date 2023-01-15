local status, saga = pcall(require, "lspsaga")
if (not status) then return end

saga.setup({})

local opts = { noremap = true, silent = true }
vim.keymap.set('n', 'K', '<Cmd>Lspsaga hover_doc<CR>', opts)
vim.keymap.set('n', 'gd', '<Cmd>Lspsaga lsp_finder<CR>', opts)
-- vim.keymap.set('i', '<C-S-k>', '<Cmd>Lspsaga signature_help<CR>', opts)
vim.keymap.set('n', 'gp', '<Cmd>Lspsaga peek_definition<CR>', opts)
vim.keymap.set('n', 'gr', '<Cmd>Lspsaga rename<CR>', opts)
vim.keymap.set({ 'n', 'v' }, '<leader>ca', '<cmd>Lspsaga code_action<CR>', opts)
vim.keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
vim.keymap.set('n', ']e', '<cmd>Lspsaga diagnostic_jump_next<CR>', opts)
-- vim.keymap.set('n', '<leader>ui', '<cmd>Lspsaga term_toggle gitui<CR>', opts)
vim.keymap.set('n', '<leader>o', '<cmd>Lspsaga outline<CR>', opts)
vim.keymap.set("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
vim.keymap.set("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")
