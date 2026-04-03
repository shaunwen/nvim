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

local zk_lsp_group = vim.api.nvim_create_augroup('ZkLspKeymaps', { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
  group = zk_lsp_group,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= 'zk' then
      return
    end

    local function follow_note_link()
      local params = vim.lsp.util.make_position_params(0, client.offset_encoding)

      vim.lsp.buf_request(args.buf, 'textDocument/definition', params, function(err, result)
        if err then
          vim.notify('zk: failed to resolve link', vim.log.levels.ERROR)
          return
        end

        if not result or vim.tbl_isempty(result) then
          vim.notify('zk: no note link found under cursor', vim.log.levels.INFO)
          return
        end

        local locations = vim.islist(result) and result or { result }
        local location = locations[1]
        if not location then
          vim.notify('zk: no note target found', vim.log.levels.INFO)
          return
        end

        vim.lsp.util.show_document(location, client.offset_encoding, { focus = true, reuse_win = true })
      end)
    end

    local opts = { buffer = args.buf, noremap = true, silent = true, desc = 'Follow note link' }
    vim.keymap.set('n', 'gd', follow_note_link, opts)
    vim.keymap.set('n', '<leader>gd', follow_note_link, opts)
    vim.keymap.set('n', '<CR>', follow_note_link, opts)
  end,
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
-- Multi-word AND search — find notes containing ALL given words (space-separated)
vim.keymap.set('n', '<leader>zF', function()
  local input = vim.fn.input('AND search (space-separated): ')
  if input == '' then return end
  local words = vim.split(input, '%s+', { trimempty = true })
  local lookaheads = {}
  for _, w in ipairs(words) do
    table.insert(lookaheads, '(?=.*' .. w .. ')')
  end
  local pattern = '(?s)' .. table.concat(lookaheads)
  local rg_cmd = 'rg -lP --multiline ' .. vim.fn.shellescape(pattern)
  local highlight_pattern = table.concat(words, '|')
  require('fzf-lua').fzf_exec(rg_cmd, {
    prompt = 'AND> ',
    previewer = false,
    preview = 'rg --color=always -in ' .. vim.fn.shellescape(highlight_pattern) .. ' {1}',
    actions = {
      ['default'] = function(selected)
        if not selected or #selected == 0 then return end
        local file = selected[1]
        vim.cmd('edit ' .. vim.fn.fnameescape(file))
        -- Use \v (very magic) so | means OR in Vim regex
        local vim_pattern = [[\v]] .. highlight_pattern
        vim.schedule(function()
          vim.fn.cursor(1, 1)
          vim.fn.search(vim_pattern, 'cW')
        end)
      end,
    },
  })
end, { desc = 'Grep notes containing ALL words' })
-- Backlinks — who links to this note?
vim.api.nvim_set_keymap('n', '<leader>zb', '<Cmd>ZkBacklinks<CR>', opts)
-- Outgoing links from this note
vim.api.nvim_set_keymap('n', '<leader>zl', '<Cmd>ZkLinks<CR>', opts)
