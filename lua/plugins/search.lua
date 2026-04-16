local function existing_dirs(paths)
  return vim.tbl_filter(function(path)
    return vim.fn.isdirectory(vim.fn.expand(path)) == 1
  end, paths)
end

local function fzf_blines()
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

local function fzf_files_by_modified_time_desc()
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

  table.sort(files, function(a, b)
    if a.mtime == b.mtime then
      return a.path < b.path
    end
    return a.mtime > b.mtime
  end)

  local opts = config.normalize_opts({
    prompt = 'RecentFiles> ',
  }, 'files')

  local entries = vim.tbl_map(function(entry)
    return make_entry.file(entry.path, opts)
  end, files)

  fzf.fzf_exec(entries, opts)
end

local function switch_git_worktree()
  require('fzf-lua').git_worktrees({
    actions = {
      ['enter'] = function(selected)
        local cwd = selected[1] and selected[1]:match('^[^%s]+')
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
              'Save or close modified buffers before switching worktrees:\n' .. table.concat(modified, '\n'),
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

          fzf_files_by_modified_time_desc()
        end)
      end,
    },
  })
end

return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'folke/snacks.nvim' },
    cmd = 'FzfLua',
    keys = {
      { '<leader>f<', '<cmd>FzfLua resume<cr>', desc = 'Resume last fzf command' },
      { '<leader>fc', '<cmd>FzfLua highlights<cr>', desc = 'Highlights' },
      { '<leader>fd', '<cmd>FzfLua lsp_document_diagnostics<cr>', desc = 'Document diagnostics' },
      { '<leader>ff', '<cmd>FzfLua files<cr>', desc = 'Find files' },
      {
        '<leader>fm',
        fzf_files_by_modified_time_desc,
        desc = 'Find most recent files by modified time',
      },
      { '<leader>b', '<cmd>FzfLua buffers<cr>', desc = 'Find files from buffers' },
      { '<leader>f/', fzf_blines, desc = 'Buffer lines', mode = { 'n', 'x' } },
      { '<leader>fg', '<cmd>FzfLua live_grep<cr>', desc = 'Grep', mode = 'n' },
      { '<leader>fg', '<cmd>FzfLua grep_visual<cr>', desc = 'Grep', mode = 'x' },
      { '<leader>fw', '<cmd>FzfLua grep_cword<cr>', desc = 'Grep word', mode = 'n' },
      { '<leader>fW', '<cmd>FzfLua grep_cWORD<cr>', desc = 'Grep WORD', mode = 'n' },
      { '<leader>fh', '<cmd>FzfLua help_tags<cr>', desc = 'Help' },
      { '<leader>fo', '<cmd>FzfLua oldfiles<cr>', desc = 'Recently opened files' },
      { 'z=', '<cmd>FzfLua spell_suggest<cr>', desc = 'Spelling suggestions' },
      { '<C-g>', '<cmd>FzfLua git_files<CR>', desc = 'Git files' },
      { '<Leader>gt', '<cmd>FzfLua git_commits<CR>', desc = 'Git commits' },
      { '<Leader>gb', '<cmd>FzfLua git_branches<CR>', desc = 'Git branches' },
      { '<Leader>gd', '<cmd>FzfLua git_diff<CR>', desc = 'Git diff' },
      { '<Leader>hf', '<cmd>FzfLua git_bcommits<CR>', desc = 'Buffer commits' },
      { '<Leader>gs', '<cmd>FzfLua git_status<CR>', desc = 'Git status' },
      { '<Leader>wt', switch_git_worktree, desc = 'Git worktrees' },
      { '<Leader>fu', '<cmd>FzfLua undotree<CR>', desc = 'Git undotree' },
      { ',a', '<cmd>FzfLua commands<cr>', desc = 'Neovim commands' },
      { '<leader>h:', '<cmd>FzfLua command_history<cr>', desc = 'Command history' },
      { '<Leader>h/', '<cmd>FzfLua search_history<cr>', desc = 'Search history' },
      { "<Leader>'", '<cmd>FzfLua marks<CR>', desc = 'Marks' },
      { '<Leader>fk', '<cmd>FzfLua keymaps<CR>', desc = 'Key mappings' },
      { '<leader>qo', '<cmd>FzfLua quickfix<cr>', desc = 'Quickfix' },
      { '<leader>qO', '<cmd>FzfLua lgrep_quickfix<cr>', desc = 'Lgrep quickfix' },
      { '<leader>fb', '<cmd>FzfLua builtin<cr>', desc = 'Builtins' },
      { '<leader>fr', '<cmd>FzfLua lsp_references<cr>', desc = 'Search references' },
      { '<leader>fs', '<cmd>FzfLua lsp_document_symbols<cr>', desc = 'Document symbols' },
      { '<leader>fS', '<cmd>FzfLua lsp_workspace_symbols<cr>', desc = 'Workspace symbols' },
    },
    config = function()
      require('config.plugins.fzf-lua')
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    cmd = 'Telescope',
    keys = {
      {
        '<leader>?',
        function()
          require('telescope.builtin').oldfiles()
        end,
        desc = 'Recent files',
      },
      {
        ',b',
        function()
          require('telescope.builtin').buffers()
        end,
        desc = 'Existing buffers',
      },
      {
        ',/',
        function()
          require('telescope.builtin').current_buffer_fuzzy_find(
            require('telescope.themes').get_dropdown({
              winblend = 10,
              previewer = false,
            })
          )
        end,
        desc = 'Search current buffer',
      },
      {
        '<Leader>gf',
        function()
          require('telescope.builtin').git_files()
        end,
        desc = 'Search git files',
      },
      {
        '<Leader>sf',
        function()
          require('telescope.builtin').find_files()
        end,
        desc = 'Search files',
      },
      {
        '<Leader>sh',
        function()
          require('telescope.builtin').help_tags()
        end,
        desc = 'Search help',
      },
      {
        '<Leader>sw',
        function()
          require('telescope.builtin').grep_string()
        end,
        desc = 'Search word',
      },
      {
        '<Leader>sg',
        function()
          require('telescope.builtin').live_grep()
        end,
        desc = 'Search grep',
      },
      {
        '<Leader>sd',
        function()
          require('telescope.builtin').diagnostics()
        end,
        desc = 'Search diagnostics',
      },
      {
        '<Leader>sr',
        function()
          require('telescope.builtin').lsp_references()
        end,
        desc = 'Search references',
      },
      {
        '<leader>sS',
        function()
          require('telescope.builtin').git_status()
        end,
        desc = 'Search git status',
      },
      {
        '<Leader>sc',
        function()
          require('telescope.builtin').commands()
        end,
        desc = 'Search commands',
      },
      {
        '<Leader>sb',
        function()
          require('telescope.builtin').buffers()
        end,
        desc = 'Search buffers',
      },
      {
        '<Leader>s/',
        function()
          require('telescope.builtin').current_buffer_fuzzy_find()
        end,
        desc = 'Current buffer fuzzy search',
      },
      {
        '<Leader>si',
        function()
          require('telescope.builtin').builtin()
        end,
        desc = 'Search builtins',
      },
      { '<leader>sm', '<cmd>Telescope harpoon marks<CR>', desc = 'Harpoon marks' },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'ThePrimeagen/harpoon',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
    },
    config = function()
      require('config.plugins.telescope')
    end,
  },
  {
    'ThePrimeagen/harpoon',
    keys = {
      {
        '<Leader>m',
        function()
          require('harpoon.mark').add_file()
        end,
        desc = 'Harpoon mark file',
      },
    },
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    config = function()
      require('config.plugins.flash')
    end,
  },
  {
    'junegunn/fzf.vim',
    lazy = false,
    dependencies = { 'junegunn/fzf' },
  },
  {
    'shaunwen/fzf-project',
    cmd = 'FzfSwitchProject',
    keys = {
      { '<Leader>pj', '<cmd>FzfSwitchProject<CR>', desc = 'Switch project' },
    },
    init = function()
      vim.g.fzfSwitchProjectWorkspaces = existing_dirs({
        '/Users/shaun.wen/workspace/projects/scalapay-repos',
        '/Users/shaun.wen/workspace/projects/scalapay-repos/worktrees',
        '/Users/shaun.wen/repo/learning/rust',
        '/Users/shaun.wen/workspace/projects/scalapay-repos/rust',
      })
      vim.g.fzfSwitchProjectProjects = existing_dirs({
        '/Users/shaun.wen/.config/nvim',
        '/Users/shaun.wen/Documents/myNotes',
      })
      vim.g.fzfSwitchProjectAlwaysChooseFile = 0
      vim.g.fzfSwitchProjectCloseOpenedBuffers = 0
    end,
  },
}
