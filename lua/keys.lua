local keymap = vim.keymap

-- Override Ctrl + i to maintain it's function for navigation as there is Tab key override below
keymap.set('n', '<C-i>', '<C-i>')

keymap.set('', ';', ':', { noremap = true })
keymap.set('n', 'H', '^')
keymap.set('n', 'L', '$')

keymap.set('n', 'x', '"_x')
keymap.set('x', '<Leader>p', "\"_dP")

keymap.set('n', '<Leader>d', "\"_d")
keymap.set('v', '<Leader>d', "\"_d")

keymap.set('v', 'gj', ":m '>+1<CR>gv=gv")
keymap.set('v', 'gk', ":m '<-2<CR>gv=gv")

keymap.set('n', 'n', 'nzzzv')
keymap.set('n', 'N', 'Nzzzv')

keymap.set('n', '<C-f>', "<cmd>silent !tmux neww tmux-sessionizer<CR>")
keymap.set("n", "gs", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
keymap.set("n", "gx", "<cmd>!chmod +x %<CR>", { silent = true })

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

-- Esc in neovim terminal
keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true })
keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>:q<CR>', { noremap = true })

-- Plugin: easymotion
-- Turn on case-insensitive feature
vim.g.EasyMotion_smartcase             = 1
-- Smartsign (type `3` and match `3`&`#`)
vim.g.EasyMotion_use_smartsign_us      = 1
vim.g.multi_cursor_select_all_word_key = '<S-C-a>'
vim.g.multi_cursor_select_all_key      = 'g<S-C-a>'

keymap.set('', '<Leader>', '<Plug>(easymotion-prefix)')
keymap.set('n', '<Leader>s', '<Plug>(easymotion-s)')
keymap.set('n', ',s', '<Plug>(easymotion-s2)')

-- Plugin chadtree
keymap.set('n', '<Leader>v', '<cmd>CHADopen<CR>')
keymap.set('n', '<Leader>ll', '<cmd>call setqflist([])<CR>')

-- Plugin: FZF
keymap.set('n', '<Leader>b', '<cmd>Buffers<CR>', { noremap = true, silent = true })
keymap.set('n', '<C-t>', '<cmd>Files<CR>', { noremap = true, silent = true })
keymap.set('n', '<C-g>', '<cmd>GFiles<CR>', { noremap = true, silent = true })
keymap.set('n', '<Leader>rg', '<cmd>Rg<CR>', { noremap = true, silent = true })
keymap.set('n', '<Leader>/', '<cmd>BLines<CR>', { noremap = true, silent = true })
keymap.set('n', '<Leader>\'', '<cmd>Marks<CR>', { noremap = true, silent = true })
keymap.set('n', '<Leader>g', '<cmd>Commits<CR>', { noremap = true, silent = true })
keymap.set('n', '<Leader>hf', '<cmd>BCommits<CR>', { noremap = true, silent = true })
keymap.set('n', '<Leader>H', '<cmd>Helptags<CR>', { noremap = true, silent = true })
keymap.set('n', '<Leader>hh', '<cmd>History<CR>', { noremap = true, silent = true })
keymap.set('n', '<Leader>h:', '<cmd>History:<CR>', { noremap = true, silent = true })
keymap.set('n', '<Leader>h/', '<cmd>History/<CR>', { noremap = true, silent = true })
vim.cmd [[
  command! -bang -nargs=* ProjectRg
    \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'dir': system('git -C '.expand('%:p:h').' rev-parse --show-toplevel 2> /dev/null')[:-2]}, <bang>0)
]]
keymap.set('n', '<Leader>f', '<cmd>ProjectRg<CR>', { noremap = true, silent = true })

-- Plugin: vsnip
vim.cmd [[
  let g:vsnip_filetypes = {}
  let g:vsnip_filetypes.javascriptreact = ['javascript']
  let g:vsnip_filetypes.typescriptreact = ['typescript']

  " Expand
  imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
  smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
  " Expand or jump
  imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
  smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
  "Jump forward or backward
  imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
  smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
  imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
  smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
]]

-- Open file in Obsidian vault
vim.cmd [[
  command! IO execute "silent !open 'obsidian://open?vault=myNotes&file=" . expand('%:r') . "'"
]]
keymap.set('n', '<Leader>io', '<cmd>IO<CR>', { noremap = true })

-- markdown-preview
keymap.set('n', '<Leader>pv', '<cmd>MarkdownPreview<CR>', { noremap = true })

vim.api.nvim_create_user_command(
  'BufOnly',
  "execute '%bdelete|edit#|bdelete#'",
  { desc = 'close all buffers except current one' }
)

-- vim-test
keymap.set('n', ',tt', '<cmd>TestNearest<CR>', { silent = true })
keymap.set('n', ',tf', '<cmd>TestFile<CR>', { silent = true })
keymap.set('n', ',ta', '<cmd>TestSuite<CR>', { silent = true })
keymap.set('n', ',tl', '<cmd>TestLast<CR>', { silent = true })
keymap.set('n', ',tg', '<cmd>TestVisit<CR>', { silent = true })

-- Allow clipboard copy paste in neovide
vim.g.neovide_input_use_logo = 1
vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true })
