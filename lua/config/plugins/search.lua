local M = {}

function M.existing_dirs(paths)
  return vim.tbl_filter(function(path)
    return vim.fn.isdirectory(vim.fn.expand(path)) == 1
  end, paths)
end

function M.fzf_blines()
  require('fzf-lua').blines({
    winopts = {
      height = 0.6,
      width = 0.5,
      preview = { vertical = 'up:70%' },
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

function M.fzf_files_by_modified_time_desc()
  local fzf = require('fzf-lua')
  local config = require('fzf-lua.config')
  local make_entry = require('fzf-lua.make_entry')
  local result = vim
    .system({
      'fd',
      '-0',
      '-t',
      'f',
      '--absolute-path',
      '--exclude',
      '.git',
      '--exclude',
      '.jj',
      '.',
    }, { text = false })
    :wait()

  if result.code ~= 0 then
    vim.notify('fd failed: ' .. (result.stderr or 'unknown error'), vim.log.levels.ERROR)
    return
  end

  local files = {}
  for _, path in ipairs(vim.split(result.stdout or '', '\0', { plain = true, trimempty = true })) do
    local stat = vim.uv.fs_stat(path)
    if stat and stat.type == 'file' then
      table.insert(files, {
        path = path,
        mtime = stat.mtime.sec,
      })
    end
  end

  -- A dominant mtime second means the tree was bulk-copied without
  -- timestamps; mtime is then useless for recency. Never triggers on healthy
  -- trees (e.g. macOS), where mtimes are real edit times.
  local counts = {}
  local stamp, stamp_count = nil, 0
  for _, f in ipairs(files) do
    counts[f.mtime] = (counts[f.mtime] or 0) + 1
  end
  for mtime, count in pairs(counts) do
    if count > stamp_count then
      stamp, stamp_count = mtime, count
    end
  end
  local copied = stamp_count >= 8 and stamp_count >= #files * 0.8

  -- Last commit date per path, newest commits first. Bounded to 2000
  -- commits; older files fall back to mtime.
  local git_dates = {}
  if copied then
    local git_root = vim.system({ 'git', 'rev-parse', '--show-toplevel' }, { text = true }):wait()
    if git_root.code == 0 and git_root.stdout and git_root.stdout ~= '' then
      local root = vim.fs.normalize(vim.trim(git_root.stdout))
      local log = vim.system(
        { 'git', 'log', '-n', '2000', '--pretty=format:%ct', '--name-only', '-z' },
        { text = false }
      ):wait()
      if log.code == 0 then
        local date
        -- git emits "<ct>\n<name>\0...": split NUL tokens, then the "\n"
        -- between each date and its first filename.
        for _, token in ipairs(vim.split(log.stdout or '', '\0', { plain = true })) do
          for _, line in ipairs(vim.split(token, '\n', { plain = true })) do
            if line:match('^%d+$') then
              date = tonumber(line)
            elseif date and line ~= '' and not git_dates[line] then
              git_dates[line] = date
            end
          end
        end
      end
      -- fd paths are absolute; git names are repo-relative.
      local function git_mtime_for(path)
        local direct = git_dates[path]
        if direct then
          return direct
        end
        if vim.startswith(path, root .. '/') then
          return git_dates[path:sub(#root + 2)]
        end
        return nil
      end
      for _, f in ipairs(files) do
        f.git_mtime = git_mtime_for(f.path)
      end
    end
  end

  table.sort(files, function(a, b)
    local function recency(f)
      if not copied then
        return f.mtime
      end
      -- Post-copy edits use real mtime; the rest use last commit date.
      if f.mtime > stamp + 3600 then
        return f.mtime
      end
      return f.git_mtime or f.mtime
    end
    local ra = recency(a)
    local rb = recency(b)
    if ra == rb then
      return a.path < b.path
    end
    return ra > rb
  end)

  local opts = config.normalize_opts({
    prompt = 'RecentFiles> ',
  }, 'files')

  local entries = vim.tbl_map(function(entry)
    return make_entry.file(entry.path, opts)
  end, files)

  fzf.fzf_exec(entries, opts)
end

function M.lspmark_create_or_edit_comment()
  local bookmarks = require('lspmark.bookmarks')
  local signs = vim.fn.sign_getplaced(vim.api.nvim_get_current_buf(), { group = 'lspmark' })
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local has_bookmark = false

  for _, placed in ipairs(signs) do
    for _, sign in ipairs(placed.signs) do
      if sign.lnum == line then
        has_bookmark = true
        break
      end
    end
    if has_bookmark then
      break
    end
  end

  if not has_bookmark then
    bookmarks.toggle_bookmark()
  end
  bookmarks.modify_comment()
end

function M.switch_git_worktree()
  local fzf = require('fzf-lua')
  local result = vim.system({ 'git', 'worktree', 'list', '--porcelain' }, { text = true }):wait()

  if result.code ~= 0 then
    vim.notify(
      'git worktree list failed: ' .. (result.stderr or 'unknown error'),
      vim.log.levels.ERROR
    )
    return
  end

  local current_cwd = vim.fn.systemlist({ 'git', 'rev-parse', '--show-toplevel' })[1]
  local entries = {}
  local worktree, branch

  local function flush_entry()
    if not worktree then
      return
    end

    local label = string.format(
      '%s %s (%s)',
      worktree == current_cwd and '*' or ' ',
      vim.fn.fnamemodify(worktree, ':t'),
      branch or 'HEAD'
    )
    table.insert(entries, worktree .. '\t' .. label)
  end

  for _, line in ipairs(vim.split(result.stdout or '', '\n', { plain = true })) do
    if vim.startswith(line, 'worktree ') then
      flush_entry()
      worktree = line:sub(#'worktree ' + 1)
      branch = nil
    elseif vim.startswith(line, 'branch ') then
      branch = line:gsub('^branch refs/heads/', '')
    elseif line == 'detached' then
      branch = 'detached'
    elseif line == '' then
      flush_entry()
      worktree = nil
      branch = nil
    end
  end
  flush_entry()

  fzf.fzf_exec(entries, {
    prompt = 'Worktrees> ',
    header = '  enter: switch  ctrl-x: delete',
    fzf_opts = {
      ['--delimiter'] = '\t',
      ['--with-nth'] = '2..',
      ['--no-multi'] = true,
    },
    preview = function(args)
      local cwd = args[1] and args[1]:match('^[^\t]+')
      if not cwd then
        return 'No worktree selected'
      end

      local status = vim
        .system({ 'git', '-C', cwd, '-c', 'color.status=always', 'status', '-s' }, { text = true })
        :wait()
      local log = vim
        .system({
          'git',
          '-C',
          cwd,
          'log',
          '--color',
          '--pretty=format:%C(yellow)%h%Creset %Cgreen(%cr)%Creset %s %C(blue)<%an>%Creset',
          '-n',
          '50',
        }, { text = true })
        :wait()

      local parts = {}
      if status.stdout and status.stdout ~= '' then
        table.insert(parts, status.stdout)
      end
      if log.stdout and log.stdout ~= '' then
        if #parts > 0 then
          table.insert(parts, '')
        end
        table.insert(parts, log.stdout)
      end
      return #parts > 0 and table.concat(parts, '\n') or ('No preview available for ' .. cwd)
    end,
    actions = {
      ['ctrl-x'] = function(selected)
        local cwd = selected[1] and selected[1]:match('^[^\t]+')
        if not cwd then
          return
        end

        if vim.fs.normalize(cwd) == vim.fs.normalize(current_cwd) then
          vim.notify("Cannot delete current worktree '" .. cwd .. "'", vim.log.levels.WARN)
          return
        end

        if vim.fn.confirm('Delete worktree ' .. cwd .. '?', '&Yes\n&No') ~= 1 then
          return
        end

        local del = vim.system({ 'git', 'worktree', 'remove', cwd }, { text = true }):wait()
        if del.code ~= 0 then
          vim.notify(
            'git worktree remove failed: ' .. (del.stderr or del.stdout or 'unknown error'),
            vim.log.levels.ERROR
          )
          return
        end

        vim.notify("Deleted worktree '" .. cwd .. "'", vim.log.levels.INFO)
        vim.schedule(M.switch_git_worktree)
      end,
      ['enter'] = function(selected)
        local cwd = selected[1] and selected[1]:match('^[^\t]+')
        if not cwd then
          return
        end

        vim.schedule(function()
          local current_buf = vim.api.nvim_get_current_buf()
          local modified = {}

          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr) then
              local name = vim.api.nvim_buf_get_name(bufnr)
              if vim.bo[bufnr].buftype == '' and name ~= '' and vim.bo[bufnr].modified then
                table.insert(modified, vim.fn.fnamemodify(name, ':~:.'))
              end
            end
          end

          if #modified > 0 then
            vim.notify(
              'Save or close modified buffers before switching worktrees:\n'
                .. table.concat(modified, '\n'),
              vim.log.levels.WARN
            )
            return
          end

          vim.cmd('cd ' .. vim.fn.fnameescape(cwd))

          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if bufnr ~= current_buf and vim.api.nvim_buf_is_valid(bufnr) then
              local name = vim.api.nvim_buf_get_name(bufnr)
              if vim.bo[bufnr].buftype == '' and name ~= '' then
                pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
              end
            end
          end

          local ok, lualine = pcall(require, 'lualine')
          if ok then
            lualine.refresh()
          end

          M.fzf_files_by_modified_time_desc()
        end)
      end,
    },
  })
end

return M
