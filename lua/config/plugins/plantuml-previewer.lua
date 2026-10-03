local M = {}

local BLOCK_DIR = vim.fn.stdpath('cache') .. '/plantuml-block'
local PLANTUML_LANGS = { plantuml = true, puml = true }

local augroup = vim.api.nvim_create_augroup('PlantumlBlockPreview', { clear = true })

local function fenced_block_at(bufnr, row)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local open_row, lang
  for i, line in ipairs(lines) do
    if not open_row then
      local info = line:match('^%s*```+%s*([%w_-]*)')
      if info then
        open_row, lang = i, info
      end
    elseif line:match('^%s*```+%s*$') then
      if row > open_row and row < i then
        return PLANTUML_LANGS[lang] and vim.list_slice(lines, open_row + 1, i - 1) or nil
      end
      open_row = nil
    end
  end
end

local function with_start_end(body)
  for _, line in ipairs(body) do
    if line:match('^%s*@start') then
      return body
    end
  end
  return vim.list_extend({ '@startuml' }, vim.list_extend(vim.deepcopy(body), { '@enduml' }))
end

local function write_block(note_bufnr)
  local body = fenced_block_at(note_bufnr, vim.api.nvim_win_get_cursor(0)[1])
  if not body then
    return nil
  end
  local note_path = vim.api.nvim_buf_get_name(note_bufnr)
  local block_path = string.format('%s/%s.puml', BLOCK_DIR, vim.fn.fnamemodify(note_path, ':t:r'))
  vim.fn.mkdir(BLOCK_DIR, 'p')
  vim.fn.writefile(with_start_end(body), block_path)
  -- The diagram is rendered from the cache dir, so resolve relative !include lines
  -- against the note's folder as if the note itself were rendered.
  vim.g['plantuml_previewer#include_path'] = vim.fn.fnamemodify(note_path, ':p:h')
  return block_path
end

local function preview_markdown_block()
  local note_bufnr = vim.api.nvim_get_current_buf()
  local block_path = write_block(note_bufnr)
  if not block_path then
    vim.notify('Cursor is not inside a ```plantuml block', vim.log.levels.WARN)
    return
  end
  -- The previewer watches the current buffer's file. bufadd keeps the block file
  -- out of the buffer list and unloaded, so it never shows up while editing.
  local block_bufnr = vim.fn.bufadd(block_path)
  vim.api.nvim_buf_call(block_bufnr, function()
    vim.cmd('PlantumlOpen')
  end)

  vim.api.nvim_clear_autocmds({ group = augroup })
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = augroup,
    buffer = note_bufnr,
    callback = function()
      if write_block(note_bufnr) then
        vim.fn['plantuml_previewer#refresh'](block_bufnr)
      end
    end,
  })
end

function M.preview()
  vim.cmd('update')
  if vim.bo.filetype == 'markdown' then
    preview_markdown_block()
  else
    vim.cmd('PlantumlOpen')
  end
end

function M.stop()
  vim.api.nvim_clear_autocmds({ group = augroup })
  vim.cmd('PlantumlStop')
end

return M
