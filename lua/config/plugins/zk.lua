require('zk').setup({
  -- can be "telescope", "fzf" or "select" (`vim.ui.select`)
  -- it's recommended to use "telescope" or "fzf"
  picker = 'fzf_lua',

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

        vim.lsp.util.show_document(
          location,
          client.offset_encoding,
          { focus = true, reuse_win = true }
        )
      end)
    end

    local opts = { buffer = args.buf, noremap = true, silent = true, desc = 'Follow note link' }
    vim.keymap.set('n', 'gd', follow_note_link, opts)
    vim.keymap.set('n', '<CR>', follow_note_link, opts)
  end,
})

local opts = { noremap = true }

zk_new_with_prompt = function(prompt, zk_opts)
  local title = vim.fn.input(prompt)
  if title == '' then
    return
  end

  local payload = vim.tbl_extend('force', { title = title }, zk_opts or {})
  require('zk.commands').get('ZkNew')(payload)
end

-- =============================================
-- Note creation
-- =============================================
-- Pick a note shape from a list, then prompt for the title and create it.
local function zk_new_from_picker(picker_prompt, entries)
  local labels = {}
  local by_label = {}
  for _, entry in ipairs(entries) do
    table.insert(labels, entry.label)
    by_label[entry.label] = entry
  end

  require('fzf-lua').fzf_exec(labels, {
    prompt = picker_prompt,
    actions = {
      ['default'] = function(selected)
        local entry = selected and by_label[selected[1]]
        if entry then
          zk_new_with_prompt(entry.prompt, entry.zk_opts)
        end
      end,
    },
  })
end

local zettel_templates = {
  {
    label = 'Quick capture',
    prompt = 'Title: ',
    zk_opts = { dir = 'zettelkasten', group = 'zettelkasten', template = 'default.md' },
  },
  {
    label = 'How-to (steps, commands, cheat sheet)',
    prompt = 'How-to: ',
    zk_opts = { dir = 'zettelkasten', group = 'zettelkasten', template = 'how_to.md' },
  },
  {
    label = 'Reference (from a video, article or book)',
    prompt = 'Reference: ',
    zk_opts = { dir = 'zettelkasten', group = 'zettelkasten', template = 'reference.md' },
  },
}

vim.keymap.set('n', '<leader>zn', function()
  zk_new_from_picker('Zettel type> ', zettel_templates)
end, { noremap = true, silent = true, desc = 'New zettel (pick type)' })
-- Create a daily note
vim.api.nvim_set_keymap(
  'n',
  '<leader>zd',
  "<Cmd>ZkNew { dir = 'DailyNotes', template = 'daily.md' }<CR>",
  opts
)

-- Work log - pick the shape that fits, then create the note accordingly
local function work_entry(label, template, prompt)
  return { label = label, prompt = prompt, zk_opts = { dir = 'work', template = template } }
end

local work_log_templates = {
  work_entry('Investigation / bug fix', 'investigation.md', 'Investigation: '),
  work_entry('General work log', 'work_log.md', 'Work log: '),
  work_entry('Meeting notes', 'meeting_note.md', 'Meeting: '),
  work_entry('PR review', 'pr_review.md', 'PR review: '),
  work_entry('Follow-up', 'followup.md', 'Follow-up: '),
}

vim.keymap.set('n', '<leader>zw', function()
  zk_new_from_picker('Work log type> ', work_log_templates)
end, { noremap = true, silent = true, desc = 'New work log (pick type)' })
-- Problem/solution — distilled after solving a real problem
vim.api.nvim_set_keymap(
  'n',
  '<leader>zP',
  "<Cmd>lua zk_new_with_prompt('Problem: ', { dir = 'work', template = 'problem_solution.md' })<CR>",
  opts
)
-- Evergreen — generalized reusable principle
vim.api.nvim_set_keymap(
  'n',
  '<leader>ze',
  "<Cmd>lua zk_new_with_prompt('Evergreen: ', { dir = 'zettelkasten', group = 'evergreen', template = 'evergreen.md' })<CR>",
  opts
)
-- Design note — architecture decisions and tradeoffs
vim.api.nvim_set_keymap(
  'n',
  '<leader>zD',
  "<Cmd>lua zk_new_with_prompt('Design: ', { dir = 'design', template = 'design_note.md' })<CR>",
  opts
)
-- Weekly review
vim.api.nvim_set_keymap(
  'n',
  '<leader>zR',
  "<Cmd>lua zk_new_with_prompt('Review: ', { dir = 'reviews', template = 'weekly_review.md' })<CR>",
  opts
)
-- Question note — explicit question to drive investigation
vim.api.nvim_set_keymap(
  'n',
  '<leader>zq',
  "<Cmd>lua zk_new_with_prompt('Question: ', { dir = 'questions', template = 'question_note.md' })<CR>",
  opts
)
-- Map of Content — hub note linking a topic cluster
vim.api.nvim_set_keymap(
  'n',
  '<leader>zm',
  "<Cmd>lua zk_new_with_prompt('MOC: ', { dir = 'zettelkasten', template = 'moc.md' })<CR>",
  opts
)

-- =============================================
-- Navigation & search
-- =============================================
-- Outline — navigate markdown headings
vim.api.nvim_set_keymap('n', '<leader>zO', '<Cmd>FzfLua blines query=^#<CR>', opts)
-- Open notes
vim.api.nvim_set_keymap('n', '<leader>zo', "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", opts)
-- Open notes by tag
vim.api.nvim_set_keymap('n', '<leader>zt', '<Cmd>ZkTags<CR>', opts)
-- Insert wiki-link to an existing note
vim.api.nvim_set_keymap('n', '<leader>zi', '<Cmd>ZkInsertLink<CR>', opts)
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
  if input == '' then
    return
  end
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
        if not selected or #selected == 0 then
          return
        end
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

-- =============================================
-- Maturity (status)
-- =============================================
local status_order = { 'seedling', 'budding', 'evergreen' }

-- zk cannot filter on frontmatter fields, so list notes by status with ripgrep.
local function zk_notes_by_status()
  require('fzf-lua').fzf_exec({ 'seedling', 'budding' }, {
    prompt = 'Status> ',
    actions = {
      ['default'] = function(selected)
        if not selected or #selected == 0 then
          return
        end
        require('fzf-lua').files({
          prompt = selected[1] .. '> ',
          cmd = 'rg -l --sortr modified -g "*.md" ' .. vim.fn.shellescape('^status: ' .. selected[1] .. '\\s*$'),
        })
      end,
    },
  })
end

local function zk_promote_status()
  local last = math.min(vim.api.nvim_buf_line_count(0), 20)
  local lines = vim.api.nvim_buf_get_lines(0, 0, last, false)
  if lines[1] ~= '---' then
    vim.notify('zk: no frontmatter in this note', vim.log.levels.WARN)
    return
  end

  for index = 2, #lines do
    if lines[index] == '---' then
      break
    end
    local current = lines[index]:match('^status:%s*(%S+)')
    if current then
      local position = vim.fn.index(status_order, current) + 1
      local promoted = status_order[position + 1]
      if position == 0 or not promoted then
        vim.notify('zk: status is ' .. current .. ', nothing to promote', vim.log.levels.INFO)
        return
      end
      vim.api.nvim_buf_set_lines(0, index - 1, index, false, { 'status: ' .. promoted })
      vim.notify('zk: ' .. current .. ' -> ' .. promoted, vim.log.levels.INFO)
      return
    end
  end
  vim.notify('zk: no status field in this note', vim.log.levels.WARN)
end

vim.keymap.set('n', '<leader>zs', zk_notes_by_status, { noremap = true, silent = true, desc = 'Notes by status' })
vim.keymap.set('n', '<leader>zu', zk_promote_status, { noremap = true, silent = true, desc = 'Promote note status' })
