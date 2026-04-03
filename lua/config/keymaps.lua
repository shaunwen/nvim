local keymap = vim.keymap

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

keymap.set('n', '<C-i>', '<C-i>')

keymap.set('', ';', ':', { noremap = true })
keymap.set('n', 'H', '^')
keymap.set('n', 'L', '$')

vim.keymap.set('n', '<Leader>gq', 'vipgq')
vim.keymap.set('n', '<Leader>U', 'viwU')
vim.keymap.set('n', '<Leader>u', 'viwu')

keymap.set('n', ',ev', ':vsplit <C-R>=expand("%:p:h") . "/" <CR>')
keymap.set('n', ',es', ':split <C-R>=expand("%:p:h") . "/" <CR>')
keymap.set('n', ',ee', ':edit <C-R>=expand("%:p:h") . "/" <CR>')

keymap.set('n', 'x', '"_x')
keymap.set('v', 'x', '"_x')
keymap.set('x', '<Leader><Leader>p', [["_dP]])

keymap.set('n', '<Leader><Leader>d', '"_d')
keymap.set('v', '<Leader><Leader>d', '"_d')

keymap.set({ 'n', 'v' }, '<Leader>y', [["+y]])
keymap.set('n', '<Leader>Y', [["+Y]])

keymap.set('v', 'gj', ":m '>+1<CR>gv=gv")
keymap.set('v', 'gk', ":m '<-2<CR>gv=gv")

keymap.set('v', '<', '<gv')
keymap.set('v', '>', '>gv')

keymap.set('n', 'n', 'nzzzv')
keymap.set('n', 'N', 'Nzzzv')

keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true })
keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true })

keymap.set('n', '<C-S-f>', '<cmd>silent !tmux neww ~/.local/bin/tmux-sessionizer<CR>')
keymap.set('n', 'gx', '<cmd>!chmod +x %<CR>', { silent = true })

local function replace_word()
  local mode = vim.api.nvim_get_mode().mode

  if mode == 'v' or mode == 'V' then
    vim.cmd('normal! "zy')
    local selected_text = vim.fn.getreg('z')
    local new_text = vim.fn.input('Replace with: ')

    vim.cmd(
      ':s/' .. vim.fn.escape(selected_text, '/') .. '/' .. vim.fn.escape(new_text, '/') .. '/gcI'
    )
    vim.cmd(
      ':.,$s/' .. vim.fn.escape(selected_text, '/') .. '/' .. vim.fn.escape(new_text, '/') .. '/gcI'
    )
    vim.cmd(
      ':1,.-1s/'
        .. vim.fn.escape(selected_text, '/')
        .. '/'
        .. vim.fn.escape(new_text, '/')
        .. '/gcI'
    )
    return
  end

  local word = vim.fn.expand('<cword>')
  local new_text = vim.fn.input('Replace with: ')

  vim.cmd(':s/\\<' .. vim.fn.escape(word, '/') .. '\\>/' .. vim.fn.escape(new_text, '/') .. '/gcI')
  vim.cmd(
    ':.,$s/\\<' .. vim.fn.escape(word, '/') .. '\\>/' .. vim.fn.escape(new_text, '/') .. '/gcI'
  )
  vim.cmd(
    ':1,.-1s/\\<' .. vim.fn.escape(word, '/') .. '\\>/' .. vim.fn.escape(new_text, '/') .. '/gcI'
  )
end

vim.keymap.set({ 'n', 'v' }, 'gs', replace_word, { noremap = true, silent = true })

keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')
keymap.set('n', 'dW', 'vb"_d')
keymap.set('n', '<C-a>', 'gg<S-v>G')

keymap.set('n', '<Leader>tl', ':tabs<CR>')
keymap.set('n', '<Leader>te', ':tabedit<CR>')
keymap.set('n', '<Leader>tc', ':tabclose<CR>')

keymap.set('n', 'ss', ':split<CR><C-w>w')
keymap.set('n', 'sv', ':vsplit<CR><C-w>w')
keymap.set('n', ',w', '<C-w>w')
keymap.set('n', 'sc', '<C-w>q')
keymap.set('', 'sh', '<C-w>h')
keymap.set('', 'sk', '<C-w>k')
keymap.set('', 'sj', '<C-w>j')
keymap.set('', 'sl', '<C-w>l')

keymap.set('n', '<s-left>', '5<C-w><')
keymap.set('n', '<s-right>', '5<C-w>>')
keymap.set('n', '<s-up>', '5<C-w>+')
keymap.set('n', '<s-down>', '5<C-w>-')

vim.keymap.set('n', '<leader>n', function()
  vim.cmd('enew')
  vim.bo.buftype = 'nofile'
  vim.bo.bufhidden = 'hide'
  vim.bo.swapfile = false
end, { desc = 'New scratch buffer' })

keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true })
keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>:q<CR>', { noremap = true })

vim.cmd([[
  command! IO execute "silent !open 'obsidian://open?vault=myNotes&file=" . expand('%:r') . "'"
]])
keymap.set('n', '<Leader>io', '<cmd>IO<CR>', { noremap = true })

vim.api.nvim_create_user_command(
  'BufOnly',
  "execute '%bdelete|edit#|bdelete#'",
  { desc = 'close all buffers except current one' }
)

if vim.g.neovide then
  vim.g.neovide_input_use_logo = 1

  vim.keymap.set('n', '<D-s>', ':w<CR>')
  vim.keymap.set('v', '<D-c>', '"+y')
  vim.keymap.set('n', '<D-v>', '"+P')
  vim.keymap.set('v', '<D-v>', '"+P')
  vim.keymap.set('c', '<D-v>', '<C-R>+')
  vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli')
end

vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true })

keymap.set('n', '<Leader>bd', '<cmd>bd!<CR>')

vim.keymap.set('n', '<leader>yp', function()
  local path = vim.fn.expand('%:p')
  vim.fn.setreg('+', path)
  print('Copied: ' .. path)
end, { desc = 'Yank file path' })

vim.keymap.set('n', '<leader>yn', function()
  local path = vim.fn.expand('%:t')
  vim.fn.setreg('+', path)
  print('Copied: ' .. path)
end, { desc = 'Yank file name' })

vim.keymap.set('n', '<leader>of', function()
  vim.fn.jobstart({ 'open', '-R', vim.fn.expand('%:p') }, { detach = true })
end, { desc = 'Open in Finder' })
