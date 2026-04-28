local ts_ok, treesitter = pcall(require, 'nvim-treesitter')
if not ts_ok then
  return
end

local textobjects_ok, textobjects = pcall(require, 'nvim-treesitter-textobjects')

local parsers = {
  'c',
  'toml',
  'go',
  'rust',
  'python',
  'json',
  'yaml',
  'html',
  'css',
  'scss',
  'javascript',
  'typescript',
  'tsx',
  'bash',
  'zsh',
  'sql',
  'lua',
  'vimdoc',
  'vim',
  'markdown',
  'markdown_inline',
  'gitignore',
  'dockerfile',
  'dot',
  'java',
  'bibtex',
  'latex',
}

local parser_set = {}
for _, parser in ipairs(parsers) do
  parser_set[parser] = true
end

treesitter.setup({
  install_dir = vim.fn.stdpath('data') .. '/site',
})

local install_opts = {
  max_jobs = 2,
  summary = true,
}

local function installed_parser_set()
  local installed = {}
  for _, parser in ipairs(treesitter.get_installed('parsers')) do
    installed[parser] = true
  end
  return installed
end

local function missing_configured_parsers()
  local installed = installed_parser_set()
  local missing = {}

  for _, parser in ipairs(parsers) do
    if not installed[parser] then
      table.insert(missing, parser)
    end
  end

  return missing
end

local function create_user_command(name, callback, opts)
  pcall(vim.api.nvim_del_user_command, name)
  vim.api.nvim_create_user_command(name, callback, opts)
end

create_user_command('TSInstallConfigured', function()
  treesitter.install(parsers, install_opts)
end, { desc = 'Install configured treesitter parsers' })

create_user_command('TSInstallMissing', function()
  local missing = missing_configured_parsers()

  if #missing == 0 then
    vim.notify('All configured treesitter parsers are installed', vim.log.levels.INFO)
    return
  end

  treesitter.install(missing, install_opts)
end, { desc = 'Install missing configured treesitter parsers' })

create_user_command('TSInstallCurrent', function()
  local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
  if not lang then
    vim.notify(
      ('No treesitter language mapped for filetype: %s'):format(vim.bo.filetype),
      vim.log.levels.WARN
    )
    return
  end

  treesitter.install(lang, { max_jobs = 1, summary = true })
end, { desc = 'Install parser for current filetype' })

create_user_command('TSUpdateSafe', function()
  treesitter.update(nil, install_opts)
end, { desc = 'Update treesitter parsers with bounded parallelism' })

vim.treesitter.language.register('tsx', { 'javascriptreact', 'typescriptreact', 'typescript.tsx' })

local large_file_bytes = 512 * 1024
local ts_group = vim.api.nvim_create_augroup('TreesitterMainApi', { clear = true })
local missing_parser_notified = {}

local function is_large_buffer(bufnr, name)
  if name ~= '' then
    local ok, stats = pcall(vim.uv.fs_stat, name)
    if ok and stats and stats.size then
      return stats.size > large_file_bytes
    end
  end

  local line_count = vim.api.nvim_buf_line_count(bufnr)
  if line_count == 0 then
    return false
  end

  local ok, byte_count = pcall(vim.api.nvim_buf_get_offset, bufnr, line_count)
  return ok and type(byte_count) == 'number' and byte_count > large_file_bytes
end

vim.api.nvim_create_autocmd('FileType', {
  group = ts_group,
  pattern = '*',
  callback = function(args)
    local filetype = vim.bo[args.buf].filetype
    local lang = vim.treesitter.language.get_lang(filetype)
    if not lang or not parser_set[lang] then
      return
    end

    local name = vim.api.nvim_buf_get_name(args.buf)
    if is_large_buffer(args.buf, name) then
      vim.b[args.buf].large_buf = true
      return
    end

    vim.b[args.buf].large_buf = false
    local started, err = pcall(vim.treesitter.start, args.buf, lang)
    if not started then
      if not missing_parser_notified[lang] then
        missing_parser_notified[lang] = true
        vim.schedule(function()
          local msg = tostring(err or '')
          if msg:find('no parser for language', 1, true) then
            vim.notify(
              ("Treesitter parser '%s' is missing. Run :TSInstallMissing"):format(lang),
              vim.log.levels.WARN
            )
          else
            vim.notify(("Treesitter failed for '%s': %s"):format(lang, msg), vim.log.levels.WARN)
          end
        end)
      end
      return
    end

    -- Keep python on its native indentexpr due long-standing treesitter indent issues.
    if lang ~= 'python' then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

if not textobjects_ok then
  return
end

textobjects.setup({
  select = {
    lookahead = true,
  },
  move = {
    set_jumps = true,
  },
})

local function map_select(lhs, query)
  vim.keymap.set({ 'x', 'o' }, lhs, function()
    require('nvim-treesitter-textobjects.select').select_textobject(query, 'textobjects')
  end, { desc = 'TS textobject ' .. query })
end

local function map_move(lhs, fn_name, query)
  vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
    require('nvim-treesitter-textobjects.move')[fn_name](query, 'textobjects')
  end, { desc = 'TS move ' .. query })
end

local function map_swap(lhs, fn_name, query)
  vim.keymap.set('n', lhs, function()
    require('nvim-treesitter-textobjects.swap')[fn_name](query, 'textobjects')
  end, { desc = 'TS swap ' .. query })
end

map_select('aa', '@parameter.outer')
map_select('ia', '@parameter.inner')
map_select('af', '@function.outer')
map_select('if', '@function.inner')
map_select('ac', '@class.outer')
map_select('ic', '@class.inner')
map_select('ai', '@conditional.outer')
map_select('ii', '@conditional.inner')
map_select('al', '@loop.outer')
map_select('il', '@loop.inner')
map_select('at', '@comment.outer')
map_select('am', '@block.outer')
map_select('im', '@block.inner')

map_move(']m', 'goto_next_start', '@function.outer')
map_move(']]', 'goto_next_start', '@class.outer')
map_move(']M', 'goto_next_end', '@function.outer')
map_move('][', 'goto_next_end', '@class.outer')
map_move('[m', 'goto_previous_start', '@function.outer')
map_move('[[', 'goto_previous_start', '@class.outer')
map_move('[M', 'goto_previous_end', '@function.outer')
map_move('[]', 'goto_previous_end', '@class.outer')

map_swap('<leader>a', 'swap_next', '@parameter.inner')
map_swap('<leader>A', 'swap_previous', '@parameter.inner')
