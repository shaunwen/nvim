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

keymap.set('n', '<Leader><Leader>u', '<cmd>packadd nvim.undotree | Undotree<CR>')

keymap.set({ 'n', 'v' }, '<Leader>y', [["+y]])
keymap.set('n', '<Leader>Y', [["+Y]])

keymap.set('v', 'gj', ":m '>+1<CR>gv=gv")
keymap.set('v', 'gk', ":m '<-2<CR>gv=gv")

keymap.set('n', 'n', 'nzzzv')
keymap.set('n', 'N', 'Nzzzv')

keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true })
keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true })

keymap.set('n', '<C-S-f>', '<cmd>silent !tmux neww ~/.local/bin/tmux-sessionizer<CR>')
keymap.set('n', 'gX', '<cmd>!chmod +x %<CR>', { silent = true })

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
  vim.bo.bufhidden = 'hide'
  vim.bo.swapfile = false
  require('fzf-lua').filetypes()
end, { desc = 'New scratch buffer' })

local jq_datadog_json_log_cmd =
  [[jq -Rs 'gsub("\n";"") | try (fromjson | walk(if type=="string" then (. as $s | try fromjson catch $s) else . end)) catch .']]

vim.keymap.set('n', '<leader>jq', function()
  vim.cmd('%!' .. jq_datadog_json_log_cmd)
  vim.bo.filetype = 'json'
end, { desc = 'Format Datadog JSON log' })

vim.keymap.set('v', '<leader>jq', function()
  vim.cmd("'<,'>!" .. jq_datadog_json_log_cmd)
  vim.bo.filetype = 'json'
end, { desc = 'Format Datadog JSON log' })

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

-- Custom function to search notes by a specific tag prefix using fzf-lua
local function search_zk_tag(tag_prefix)
  local fzf = require('fzf-lua')
  local result = vim.system({ 'zk', 'list', '--format', 'json' }, { text = true }):wait()
  if result.code ~= 0 then
    vim.notify('zk search failed: ' .. (result.stderr or 'unknown error'), vim.log.levels.ERROR)
    return
  end

  local ok, notes = pcall(vim.json.decode, result.stdout)
  if not ok or type(notes) ~= 'table' then
    vim.notify('zk search failed: invalid JSON output', vim.log.levels.ERROR)
    return
  end

  local matches = {}
  for _, note in ipairs(notes) do
    for _, tag in ipairs(note.tags or {}) do
      if string.find(tag, tag_prefix, 1, true) then
        table.insert(matches, note.absPath or note.path)
        break
      end
    end
  end

  if vim.tbl_isempty(matches) then
    vim.notify('No notes found for tag fragment: ' .. tag_prefix, vim.log.levels.INFO)
    return
  end

  fzf.fzf_exec(matches, {
    actions = {
      ['default'] = fzf.actions.file_edit,
      ['ctrl-q'] = {
        fn = fzf.actions.file_sel_to_qf,
        prefix = 'select-all',
      },
    },
    previewer = 'builtin',
    fzf_opts = {
      ['--multi'] = true,
    },
    winopts = { title = ' ZK PARA tag search: ' .. tag_prefix },
  })
end

local function prompt_search_zk_tag()
  local tag_fragment = vim.fn.input('Tag fragment: ')
  if tag_fragment == '' then
    return
  end
  search_zk_tag(tag_fragment)
end

-- Keymap for PARA layer search
vim.keymap.set('n', '<leader>zP', function()
  search_zk_tag('p/')
end, { desc = 'Search projects' })
vim.keymap.set('n', '<leader>za', function()
  search_zk_tag('a/')
end, { desc = 'Search areas' })
vim.keymap.set('n', '<leader>zR', function()
  search_zk_tag('r/')
end, { desc = 'Search resources' })
vim.keymap.set('n', '<leader>zx', function()
  search_zk_tag('x/')
end, { desc = 'Search archives' })
vim.keymap.set('n', '<leader>zk', prompt_search_zk_tag, { desc = 'Search zk tags' })
