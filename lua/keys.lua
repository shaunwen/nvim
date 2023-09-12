local keymap = vim.keymap

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Override Ctrl + i to maintain it's function for navigation as there is Tab key override below
keymap.set('n', '<C-i>', '<C-i>')

keymap.set('', ';', ':', { noremap = true })
keymap.set('n', 'H', '^')
keymap.set('n', 'L', '$')

-- Align/wrap current paragraph
vim.keymap.set('n', '<Leader>gq', 'vipgq')
-- make word upper/lower case
vim.keymap.set('n', '<Leader>U', 'viwU')
vim.keymap.set('n', '<Leader>u', 'viwu')
-- Open any file in the same directory in a vsplit,
-- but where you can type and auto-complete the filename
keymap.set('n', '<Leader>ev', ':vsplit <C-R>=expand("%:p:h") . "/" <CR>')
keymap.set('n', '<Leader>es', ':split <C-R>=expand("%:p:h") . "/" <CR>')
keymap.set('n', '<Leader>ee', ':edit <C-R>=expand("%:p:h") . "/" <CR>')

keymap.set('n', 'x', '"_x')
keymap.set('x', '<Leader>p', [["_dP]])

keymap.set('n', '<Leader><Leader>d', "\"_d")
keymap.set('v', '<Leader><Leader>d', "\"_d")

keymap.set({ "n", "v" }, "<Leader>y", [["+y]])
keymap.set("n", "<Leader>Y", [["+Y]])

keymap.set('v', 'gj', ":m '>+1<CR>gv=gv")
keymap.set('v', 'gk', ":m '<-2<CR>gv=gv")

keymap.set('v', '<', '<gv')
keymap.set('v', '>', '>gv')

keymap.set('n', 'n', 'nzzzv')
keymap.set('n', 'N', 'Nzzzv')

keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true })
keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true })

keymap.set('n', '<C-S-f>', "<cmd>silent !tmux neww ~/.local/bin/tmux-sessionizer<CR>")
keymap.set("n", "gs", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
keymap.set("n", "gx", "<cmd>!chmod +x %<CR>", { silent = true })

-- Increment/decrement
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- Delete a word backwards
keymap.set('n', 'dW', 'vb"_d')

-- Select all
keymap.set('n', '<C-a>', 'gg<S-v>G')

-- List/open/close tab
keymap.set('n', 'tl', ':tabs<CR>')
keymap.set('n', 'te', ':tabedit<CR>')
keymap.set('n', 'tc', ':tabclose<CR>')
-- Split window
keymap.set('n', 'ss', ':split<CR><C-w>w')
keymap.set('n', 'sv', ':vsplit<CR><C-w>w')
-- Move window
keymap.set('n', ',w', '<C-w>w')
keymap.set('n', 'sc', '<C-w>q')
keymap.set('', 'sh', '<C-w>h')
keymap.set('', 'sk', '<C-w>k')
keymap.set('', 'sj', '<C-w>j')
keymap.set('', 'sl', '<C-w>l')
-- Resize window
keymap.set('n', '<s-left>', '5<C-w><')
keymap.set('n', '<s-right>', '5<C-w>>')
keymap.set('n', '<s-up>', '5<C-w>+')
keymap.set('n', '<s-down>', '5<C-w>-')

-- Esc in neovim terminal
keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true })
keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>:q<CR>', { noremap = true })

-- Plugin: easymotion
-- Turn on case-insensitive feature
-- vim.g.EasyMotion_smartcase             = 1
-- Smartsign (type `3` and match `3`&`#`)
-- vim.g.EasyMotion_use_smartsign_us      = 1
-- vim.g.multi_cursor_select_all_word_key = '<S-C-a>'
-- vim.g.multi_cursor_select_all_key      = 'g<S-C-a>'

-- keymap.set('', '<Leader>', '<Plug>(easymotion-prefix)')
-- keymap.set('n', '<Leader>s', '<Plug>(easymotion-s)')
-- keymap.set('n', ',s', '<Plug>(easymotion-s2)')

-- Plugin chadtree
keymap.set('n', '<Leader>v', '<cmd>CHADopen<CR>')
keymap.set('n', '<Leader>ll', '<cmd>call setqflist([])<CR>')

-- Plugin: FZF
keymap.set('n', '<Leader>b', '<cmd>Buffers<CR>', { noremap = true, silent = true })
keymap.set('n', '<C-t>', '<cmd>Files<CR>', { noremap = true, silent = true })
keymap.set('n', '<C-g>', '<cmd>GFiles<CR>', { noremap = true, silent = true })
keymap.set('n', '<Leader>rg', '<cmd>Rg<CR>', { noremap = true, silent = true })
keymap.set('n', ',a', '<cmd>Commands<CR>', { noremap = true, silent = true })
keymap.set('n', '<Leader>/', '<cmd>BLines<CR>', { noremap = true, silent = true })
keymap.set('n', '<Leader>\'', '<cmd>Marks<CR>', { noremap = true, silent = true })
keymap.set('n', '<Leader>gt', '<cmd>Commits<CR>', { noremap = true, silent = true })
keymap.set('n', '<Leader>hf', '<cmd>BCommits<CR>', { noremap = true, silent = true })
keymap.set('n', '<Leader>H', '<cmd>Helptags<CR>', { noremap = true, silent = true })
keymap.set('n', '<Leader>hh', '<cmd>History<CR>', { noremap = true, silent = true })
keymap.set('n', '<Leader>h:', '<cmd>History:<CR>', { noremap = true, silent = true })
keymap.set('n', '<Leader>h/', '<cmd>History/<CR>', { noremap = true, silent = true })
vim.cmd [[
  command! -bang -nargs=* ProjectRg
    \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case "
    \ .shellescape(<q-args>), 1, {
    \ 'dir': system('git -C '.expand('%:p:h').' rev-parse --show-toplevel 2> /dev/null')[:-2],
    \ 'options': '--ansi --preview "bat --color=always --style=header,grid,numbers --highlight-line {2} {1} | head -500"'
    \ }, <bang>0)
]]
keymap.set('n', '<Leader>f', '<cmd>ProjectRg<CR>', { noremap = true, silent = true })
keymap.set('n', '<Leader><Tab>', '<Plug>(fzf-maps-n)')
keymap.set('x', '<Leader><Tab>', '<Plug>(fzf-maps-x)')
keymap.set('i', '<C-x>m', '<Plug>(fzf-maps-i)')
keymap.set('o', '<Leader><Tab>', '<Plug>(fzf-maps-o)')
keymap.set('i', '<C-x>w', '<Plug>(fzf-complete-word)')
keymap.set('i', '<C-x>p', '<Plug>(fzf-complete-path)')
keymap.set('i', '<C-x>l', '<Plug>(fzf-complete-line)')

vim.cmd [[
  command! -bang -nargs=* CustomBLines
      \ call fzf#vim#grep(
      \   'rg --with-filename --column --line-number --no-heading --smart-case . '.fnameescape(expand('%:p')), 1,
      \   fzf#vim#with_preview({'options': '--keep-right --delimiter : --nth 4.. --preview "bat -p --color always {}"'}, 'right:60%' ))
  nnoremap <leader>/ :CustomBLines<Cr>
]]

-- Plugin: vsnip
-- vim.cmd [[
--   let g:vsnip_filetypes = {}
--   let g:vsnip_filetypes.javascriptreact = ['javascript']
--   let g:vsnip_filetypes.typescriptreact = ['typescript']
-- ]]
-- Jump forward or backward
-- vim.keymap.set({ 'i', 's' }, '<Tab>', function()
--   return vim.fn['vsnip#jumpable'](1) == 1 and '<Plug>(vsnip-jump-next)' or '<Tab>'
-- end, { expr = true })
-- vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
--   return vim.fn['vsnip#jumpable'](-1) == 1 and '<Plug>(vsnip-jump-prev)' or '<S-Tab>'
-- end, { expr = true })

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
if vim.g.neovide then
  vim.g.neovide_input_use_logo = 1

  vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
  vim.keymap.set('v', '<D-c>', '"+y') -- Copy
  vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
  vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode
end

-- Allow clipboard copy paste in neovim
vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true})


keymap.set('n', '<Leader>pj', ':FzfSwitchProject<CR>')

-- DAP Plugin
keymap.set('n', '<Leader>db', ":DapToggleBreakpoint<CR>")
keymap.set('n', '<Leader>rd', ":RustDebuggables<CR>")
keymap.set('n', '<F9>', ":DapContinue<CR>")
keymap.set('n', '<Leader>do', ":lua require('dapui').open()<CR>")
keymap.set('n', '<Leader>dO', ":lua require('dapui').close()<CR>")
keymap.set('n', '<Leader>dt', ":lua require('dapui').toggle()<CR>")
keymap.set('n', '<F8>', ':lua require"dap".step_over()<CR>')
keymap.set('n', '<F7>', ':lua require"dap".step_into()<CR>')
vim.api.nvim_set_keymap('n', '<F12>', [[:lua require"dap.ui.widgets".hover()<CR>]], { noremap = true })
vim.api.nvim_set_keymap('n', '<F5>', [[:lua require"osv".launch({port = 8086})<CR>]], { noremap = true })

-- formatter
keymap.set({ 'n', 'v' }, ',f', "<cmd>Format<CR>")

-- force delete buffer, can be used for deleting neovim builtin terminals
keymap.set('n', '<Leader>tc', "<cmd>bd!<CR>")
