local keymap = vim.keymap

-- Override Ctrl + i to maintain it's function for navigation as there is Tab key override below
keymap.set('n', '<C-i>', '<C-i>')

keymap.set('', ';', ':', {noremap = true})
keymap.set('n', 'H', '^')
keymap.set('n', 'L', '$')

keymap.set('n', 'x', '"_x')

-- Increment/decrement
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- Delete a word backwards
keymap.set('n', 'dW', 'vb"_d')

-- Select all
keymap.set('n', '<C-a>', 'gg<S-v>G')

-- New tab
keymap.set('n', 'tl', ':tabs<CR>')
keymap.set('n', 'te', ':tabedit<CR>')
keymap.set('n', 'tc', ':tabclose<CR>')
-- Split window
keymap.set('n', 'ss', ':split<CR><C-w>w')
keymap.set('n', 'sv', ':vsplit<CR><C-w>w')
-- Move window
keymap.set('n', '<Space>w', '<C-w>w')
keymap.set('n', 'sc', '<C-w>q')
keymap.set('', 'sh', '<C-w>h')
keymap.set('', 'sk', '<C-w>k')
keymap.set('', 'sj', '<C-w>j')
keymap.set('', 'sl', '<C-w>l')
-- Resize window
keymap.set('n', 's<left>', '5<C-w><')
keymap.set('n', 's<right>', '5<C-w>>')
keymap.set('n', 's<up>', '5<C-w>+')
keymap.set('n', 's<down>', '5<C-w>-')

-- Plugin: easymotion
keymap.set('', '<Leader>', '<Plug>(easymotion-prefix)')
keymap.set('n', '<Leader>s', '<Plug>(easymotion-s)')
keymap.set('n', ',s', '<Plug>(easymotion-s2)')

-- Plugin chadtree
keymap.set('n', '<leader>v', '<cmd>CHADopen<cr>')
keymap.set('n', '<leader>ll', '<cmd>call setqflist([])<cr>')

-- Esc in neovim terminal
keymap.set('t', '<Esc>', '<C-\\><C-n>:q<CR>', {noremap = true})

