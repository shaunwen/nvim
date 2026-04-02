require('zk').setup({
  -- can be "telescope", "fzf" or "select" (`vim.ui.select`)
  -- it's recommended to use "telescope" or "fzf"
  picker = 'fzf',

  lsp = {
    -- `config` is passed to `vim.lsp.start_client(config)`
    config = {
      cmd = { 'zk', 'lsp' },
      name = 'zk',
      -- on_attach = ...
      -- etc, see `:h vim.lsp.start_client()`
    },

    -- automatically attach buffers in a zk notebook that match the given filetypes
    auto_attach = {
      enabled = true,
      filetypes = { 'markdown' },
    },
  },
})

local opts = { noremap = true }

-- =============================================
-- Note creation
-- =============================================
-- Create a new zettelkasten note (seedling, inbox)
vim.api.nvim_set_keymap(
  'n',
  '<leader>zn',
  "<Cmd>ZkNew { title = vim.fn.input('Title: '), dir = 'zettelkasten', template = 'default.md' }<CR>",
  opts
)
-- Create a daily note
vim.api.nvim_set_keymap(
  'n',
  '<leader>zd',
  "<Cmd>ZkNew { dir = 'DailyNotes', template = 'daily.md' }<CR>",
  opts
)

-- Work log — messy live capture during debugging/investigation
vim.api.nvim_set_keymap(
  'n',
  '<leader>zw',
  "<Cmd>ZkNew { title = vim.fn.input('Work log: '), dir = 'work', template = 'work_log.md' }<CR>",
  opts
)
-- Problem/solution — distilled after solving a real problem
vim.api.nvim_set_keymap(
  'n',
  '<leader>zp',
  "<Cmd>ZkNew { title = vim.fn.input('Problem: '), dir = 'work', template = 'problem_solution.md' }<CR>",
  opts
)
-- Evergreen — generalized reusable principle
vim.api.nvim_set_keymap(
  'n',
  '<leader>ze',
  "<Cmd>ZkNew { title = vim.fn.input('Evergreen: '), dir = 'zettelkasten', template = 'evergreen.md' }<CR>",
  opts
)
-- Design note — architecture decisions and tradeoffs
vim.api.nvim_set_keymap(
  'n',
  '<leader>zD',
  "<Cmd>ZkNew { title = vim.fn.input('Design: '), dir = 'design', template = 'design_note.md' }<CR>",
  opts
)
-- Weekly review
vim.api.nvim_set_keymap(
  'n',
  '<leader>zr',
  "<Cmd>ZkNew { dir = 'reviews', template = 'weekly_review.md' }<CR>",
  opts
)
-- Question note — explicit question to drive investigation
vim.api.nvim_set_keymap(
  'n',
  '<leader>zq',
  "<Cmd>ZkNew { title = vim.fn.input('Question: '), dir = 'questions', template = 'question_note.md' }<CR>",
  opts
)
-- Map of Content — hub note linking a topic cluster
vim.api.nvim_set_keymap(
  'n',
  '<leader>zm',
  "<Cmd>ZkNew { title = vim.fn.input('MOC: '), dir = 'zettelkasten', template = 'moc.md' }<CR>",
  opts
)

-- =============================================
-- Navigation & search
-- =============================================
-- Open notes
vim.api.nvim_set_keymap('n', '<leader>zo', "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", opts)
-- Open notes by tag
vim.api.nvim_set_keymap('n', '<leader>zt', '<Cmd>ZkTags<CR>', opts)
-- Insert wiki-link to an existing note
vim.api.nvim_set_keymap(
  'n',
  '<leader>zi',
  "<Cmd>ZkInsertLink<CR>",
  opts
)
-- Search notes by content
vim.api.nvim_set_keymap(
  'n',
  '<leader>zf',
  "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
  opts
)
-- Search notes matching visual selection
vim.api.nvim_set_keymap('v', '<leader>zf', ":'<,'>ZkMatch<CR>", opts)
-- Backlinks — who links to this note?
vim.api.nvim_set_keymap('n', '<leader>zb', '<Cmd>ZkBacklinks<CR>', opts)
-- Outgoing links from this note
vim.api.nvim_set_keymap('n', '<leader>zl', '<Cmd>ZkLinks<CR>', opts)
