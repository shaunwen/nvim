require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran', term_seq_bias = 0.5 }

-- Changing the default f keyword
vim.keymap.set({ "n", "v" }, 'f', "<cmd>lua require'hop'.hint_char2({ multi_windows = true })<cr>", {})

-- Pattern matching with t keyword
vim.api.nvim_set_keymap('n', 't', "<cmd>HopPattern<CR>", { noremap = true })

-- Line matching
vim.keymap.set({ "n", "v" }, '<Leader><Leader>l', "<cmd>HopLine<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>lm', "<cmd>HopLineMW<CR>", { noremap = true })
