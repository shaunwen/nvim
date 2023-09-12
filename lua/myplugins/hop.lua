require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran', term_seq_bias = 0.5 }

-- Changing the default f keyword
vim.api.nvim_set_keymap('', 'f', "<cmd>lua require'hop'.hint_char1()<cr>", {})
vim.api.nvim_set_keymap('', '<Leader>s', "<cmd>lua require'hop'.hint_char2({ multi_windows = true })<cr>", {})

-- Pattern Matching with t keyword
vim.api.nvim_set_keymap('n', 't', "<cmd>HopPattern<CR>", { noremap = true })
