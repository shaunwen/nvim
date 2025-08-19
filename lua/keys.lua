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
-- keymap.set("n", "gs", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
keymap.set('n', 'gx', '<cmd>!chmod +x %<CR>', { silent = true })

local function replace_word()
  -- Get the current mode
  local mode = vim.api.nvim_get_mode().mode

  if mode == 'v' or mode == 'V' then
    -- If in visual mode, use the visual selection range
    vim.cmd('normal! "zy')
    local selected_text = vim.fn.getreg('z')
    local new_text = vim.fn.input('Replace with: ')
    -- Start replacement from the currently selected text
    vim.cmd(
      ':s/' .. vim.fn.escape(selected_text, '/') .. '/' .. vim.fn.escape(new_text, '/') .. '/gcI'
    )
    -- Extend replacement to the rest of the file starting from the current line
    vim.cmd(
      ':.,$s/' .. vim.fn.escape(selected_text, '/') .. '/' .. vim.fn.escape(new_text, '/') .. '/gcI'
    )
    -- Wrap around and replace from the top of the file to the current line
    vim.cmd(
      ':1,.-1s/'
        .. vim.fn.escape(selected_text, '/')
        .. '/'
        .. vim.fn.escape(new_text, '/')
        .. '/gcI'
    )
  else
    -- If in normal mode, replace the word under the cursor in the entire file
    local word = vim.fn.expand('<cword>')
    local new_text = vim.fn.input('Replace with: ')
    -- Start replacement from the word under the cursor
    vim.cmd(
      ':s/\\<' .. vim.fn.escape(word, '/') .. '\\>/' .. vim.fn.escape(new_text, '/') .. '/gcI'
    )
    -- Extend replacement to the rest of the file starting from the current line
    vim.cmd(
      ':.,$s/\\<' .. vim.fn.escape(word, '/') .. '\\>/' .. vim.fn.escape(new_text, '/') .. '/gcI'
    )
    -- Wrap around and replace from the top of the file to the current line
    vim.cmd(
      ':1,.-1s/\\<' .. vim.fn.escape(word, '/') .. '\\>/' .. vim.fn.escape(new_text, '/') .. '/gcI'
    )
  end
end

vim.keymap.set({ 'n', 'v' }, 'gs', replace_word, { noremap = true, silent = true })

-- Increment/decrement
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- Delete a word backwards
keymap.set('n', 'dW', 'vb"_d')

-- Select all
keymap.set('n', '<C-a>', 'gg<S-v>G')

-- List/open/close tab
keymap.set('n', '<Leader>tl', ':tabs<CR>')
keymap.set('n', '<Leader>te', ':tabedit<CR>')
keymap.set('n', '<Leader>tc', ':tabclose<CR>')
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

-- Plugin nvimtree
vim.keymap.set('n', '<Leader>v', ':NvimTreeFindFileToggle<CR>')
-- Plugin mini.files
local function open_curren_file()
  local bufname = vim.api.nvim_buf_get_name(0)
  local path = vim.fn.fnamemodify(bufname, ':p')

  -- Noop if the buffer isn't valid.
  if path and vim.uv.fs_stat(path) then
    require('mini.files').open(bufname, false)
  end
end
keymap.set('n', '<Leader>e', open_curren_file, { desc = 'Open Mini Files at current file' })
-- keymap.set('n', '<Leader>e', '<cmd>lua MiniFiles.open()<CR>')

local function fzf_blines()
  require('fzf-lua').blines({
    winopts = {
      height = 0.6,
      width = 0.5,
      preview = { vertical = 'up:70%' },
      -- Disable Treesitter highlighting for the matches.
      treesitter = {
        enabled = false,
        fzf_colors = { ['fg'] = { 'fg', 'CursorLine' }, ['bg'] = { 'bg', 'Normal' } },
      },
    },
    fzf_opts = {
      ['--layout'] = 'reverse',
    },
  })
end

-- keymap for fzf-lua
keymap.set('n', '<leader>f<', '<cmd>FzfLua resume<cr>', { desc = 'Resume last fzf command' })
keymap.set(
  'n',
  '<leader>fc',
  '<cmd>FzfLua highlights<cr>',
  { desc = 'Highlights', noremap = true, silent = true }
)
keymap.set(
  'n',
  '<leader>fd',
  '<cmd>FzfLua lsp_document_diagnostics<cr>',
  { desc = 'Document diagnostics', noremap = true, silent = true }
)
keymap.set(
  'n',
  '<leader>ff',
  '<cmd>FzfLua files<cr>',
  { desc = 'Find files', noremap = true, silent = true }
)
keymap.set(
  'n',
  '<leader>fb',
  '<cmd>FzfLua buffers<cr>',
  { desc = 'Find files from buffers', noremap = true, silent = true }
)
keymap.set({ 'n', 'x' }, '<leader>f/', fzf_blines, { desc = 'Buffer lines' })
keymap.set(
  'n',
  '<leader>fg',
  '<cmd>FzfLua live_grep<cr>',
  { desc = 'Grep', noremap = true, silent = true }
)
keymap.set(
  'x',
  '<leader>fg',
  '<cmd>FzfLua grep_visual<cr>',
  { desc = 'Grep', noremap = true, silent = true }
)
keymap.set(
  'n',
  '<leader>fh',
  '<cmd>FzfLua help_tags<cr>',
  { desc = 'Help', noremap = true, silent = true }
)
keymap.set(
  'n',
  '<leader>fr',
  '<cmd>FzfLua oldfiles<cr>',
  { desc = 'Recently opened files', noremap = true, silent = true }
)
keymap.set(
  'n',
  'z=',
  '<cmd>FzfLua spell_suggest<cr>',
  { desc = 'Spelling suggestions', noremap = true, silent = true }
)
-- git
keymap.set('n', '<C-g>', '<cmd>FzfLua git_files<CR>', { noremap = true, silent = true })
keymap.set('n', '<Leader>gt', '<cmd>FzfLua git_commits<CR>', { noremap = true, silent = true })
keymap.set('n', '<Leader>gb', '<cmd>FzfLua git_branches<CR>', { noremap = true, silent = true })
keymap.set('n', '<Leader>gd', '<cmd>FzfLua git_diff<CR>', { noremap = true, silent = true })
keymap.set('n', '<Leader>hf', '<cmd>FzfLua git_bcommits<CR>', { noremap = true, silent = true })
-- extra
keymap.set(
  'n',
  ',a',
  '<cmd>FzfLua commands<cr>',
  { desc = 'Neovim commands', noremap = true, silent = true }
)
keymap.set(
  'n',
  '<leader>h:',
  '<cmd>FzfLua command_history<cr>',
  { desc = 'Command history', noremap = true, silent = true }
)
keymap.set(
  'n',
  '<Leader>h/',
  '<cmd>FzfLua search_history<cr>',
  { desc = 'Search history', noremap = true, silent = true }
)
keymap.set('n', "<Leader>'", '<cmd>FzfLua marks<CR>', { noremap = true, silent = true })
keymap.set(
  'n',
  '<Leader>fk',
  '<cmd>FzfLua keymaps<CR>',
  { desc = 'Key mappings', noremap = true, silent = true }
)

-- Open file in Obsidian vault
vim.cmd([[
  command! IO execute "silent !open 'obsidian://open?vault=myNotes&file=" . expand('%:r') . "'"
]])
keymap.set('n', '<Leader>io', '<cmd>IO<CR>', { noremap = true })

-- markdown-preview
keymap.set('n', '<Leader>pv', '<cmd>MarkdownPreview<CR>', { noremap = true })
keymap.set('n', '<Leader>mv', '<cmd>Vivify<CR>', { noremap = true })
keymap.set('n', '<Leader>mp', '<cmd>MarkmapWatch<CR>', { noremap = true })

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
vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true })

keymap.set('n', '<Leader>pj', ':FzfSwitchProject<CR>')

-- DAP Plugin
keymap.set('n', '<Leader>db', ':DapToggleBreakpoint<CR>')
keymap.set('n', '<Leader>rr', ':RustRunnables<CR>')
keymap.set('n', '<Leader>rd', ':RustDebuggables<CR>')
keymap.set('n', '<F9>', ':DapContinue<CR>')
keymap.set('n', '<Leader>do', ":lua require('dapui').open()<CR>")
keymap.set('n', '<Leader>dO', ":lua require('dapui').close()<CR>")
keymap.set('n', '<Leader>dt', ":lua require('dapui').toggle()<CR>")
keymap.set('n', '<F8>', ':lua require"dap".step_over()<CR>')
keymap.set('n', '<F7>', ':lua require"dap".step_into()<CR>')
vim.api.nvim_set_keymap(
  'n',
  '<F12>',
  [[:lua require"dap.ui.widgets".hover()<CR>]],
  { noremap = true }
)
vim.api.nvim_set_keymap(
  'n',
  '<F5>',
  [[:lua require"osv".launch({port = 8086})<CR>]],
  { noremap = true }
)

-- code formatting
keymap.set({ 'n' }, ',f', function()
  require('conform').format({
    lsp_format = 'fallback',
  })
end, { desc = 'Format current file' })

-- force delete buffer, can be used for deleting neovim builtin terminals
keymap.set('n', '<Leader>tc', '<cmd>bd!<CR>')

keymap.set('n', '<Leader>m', "<cmd>lua require('harpoon.mark').add_file()<CR>")
