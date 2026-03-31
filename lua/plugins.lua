vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration
  'tpope/vim-surround',
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
  },
  'terryma/vim-multiple-cursors',
  'godlygeek/tabular',
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },
  'folke/snacks.nvim',
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('myplugins.autopairs')
    end,
  },
  'windwp/nvim-ts-autotag',
  {
    'glepnir/lspsaga.nvim',
    event = 'LspAttach',
    config = function()
      require('myplugins.lspsaga')
    end,
  },
  { 'nvim-tree/nvim-web-devicons', opts = {} },
  'onsails/lspkind-nvim',

  -- Git related plugins
  'tpope/vim-fugitive',
  'tommcdo/vim-fubitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  'nvim-tree/nvim-tree.lua',
  { 'echasnovski/mini.files', version = '*' },

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
    },
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- improves Mason's language filter and UI
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
  },
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },
  {
    -- Modern completion engine with better performance
    'saghen/blink.cmp',
    dependencies = {
      -- Snippet Engine & its associated source
      'L3MON4D3/LuaSnip',
      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
      -- Copilot integration for blink.cmp
      'fang2hou/blink-copilot',
    },
    version = '1.*',
    -- Configuration is in myplugins/blink-cmp.lua
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('myplugins.gitsigns')
    end,
  },

  -- Themes
  -- 'morhetz/gruvbox',
  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    main = 'ibl',
    opts = {},
  },

  -- 'gc' to comment visual regions/lines
  {
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
    config = function()
      require('myplugins.comment')
    end,
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
    },
  },
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
  'ThePrimeagen/harpoon',
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    lazy = false,
    opts = {},
  },
  -- Markdown
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = 'cd app && npm install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
  },
  { 'bullets-vim/bullets.vim' },
  -- markdown preview with clikable links
  { 'jannis-baum/vivify.vim' },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you use the mini.nvim suite
    config = function()
      require('myplugins.render-markdown')
    end,
  },
  -- mindmap rendering for markdown
  {
    'Zeioth/markmap.nvim',
    build = 'yarn global add markmap-cli',
    cmd = { 'MarkmapOpen', 'MarkmapSave', 'MarkmapWatch', 'MarkmapWatchStop' },
    opts = {
      html_output = '/tmp/markmap.html', -- (default) Setting a empty string '' here means: [Current buffer path].html
      hide_toolbar = false, -- (default)
      grace_period = 3600000, -- (default) Stops markmap watch after 60 minutes. Set it to 0 to disable the grace_period.
    },
    config = function(_, opts)
      require('markmap').setup(opts)
    end,
  },

  {
    'mickael-menu/zk-nvim',
    lazy = true,
  },
  { 'aklt/plantuml-syntax' },
  {
    'mfussenegger/nvim-dap',
    keys = {
      {
        '<Leader>db',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'DAP toggle breakpoint',
      },
      {
        '<F9>',
        function()
          require('dap').continue()
        end,
        desc = 'DAP continue',
      },
      {
        '<Leader>do',
        function()
          require('dapui').open()
        end,
        desc = 'DAP UI open',
      },
      {
        '<Leader>dO',
        function()
          require('dapui').close()
        end,
        desc = 'DAP UI close',
      },
      {
        '<Leader>dt',
        function()
          require('dapui').toggle()
        end,
        desc = 'DAP UI toggle',
      },
      {
        '<F8>',
        function()
          require('dap').step_over()
        end,
        desc = 'DAP step over',
      },
      {
        '<F7>',
        function()
          require('dap').step_into()
        end,
        desc = 'DAP step into',
      },
      {
        '<F12>',
        function()
          require('dap.ui.widgets').hover()
        end,
        desc = 'DAP hover',
      },
      {
        '<F5>',
        function()
          require('osv').launch({ port = 8086 })
        end,
        desc = 'Launch OSV',
      },
    },
    dependencies = {
      {
        'rcarriga/nvim-dap-ui',
        dependencies = {
          'nvim-neotest/nvim-nio',
        },
      },
      'mxsdev/nvim-dap-vscode-js',
      'jbyuki/one-small-step-for-vimkind',
    },
    config = function()
      require('myplugins.dap').setup()
    end,
  },
  -- Lua
  -- Rust
  {
    'mrcjkb/rustaceanvim',
    version = '^6', -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  -- Node
  'tpope/vim-abolish',
  'junegunn/fzf',
  'junegunn/fzf.vim',
  'shaunwen/fzf-project',
  {
    'akinsho/toggleterm.nvim',
    keys = {
      {
        '<leader>tt',
        function()
          require('myplugins.toggleterm').toggle_float()
        end,
        desc = 'Toggle floating terminal',
      },
      {
        '<leader>ui',
        function()
          require('myplugins.toggleterm').toggle_gitui()
        end,
        desc = 'Toggle gitui terminal',
      },
      {
        '<leader>py',
        function()
          require('myplugins.toggleterm').toggle_python()
        end,
        desc = 'Toggle python terminal',
      },
      {
        '<leader>ts',
        function()
          require('myplugins.toggleterm').toggle_horizontal()
        end,
        desc = 'Toggle horizontal terminal',
      },
      {
        '<leader>tv',
        function()
          require('myplugins.toggleterm').toggle_vertical()
        end,
        desc = 'Toggle vertical terminal',
      },
    },
    cmd = { 'ToggleTerm', 'TermExec' },
    config = function()
      require('myplugins.toggleterm').setup()
    end,
  },
  'stevearc/conform.nvim',

  {
    'tpope/vim-dadbod',
    ft = { 'sql', 'mysql', 'plsql' },
    cmd = { 'DB', 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer', 'DBUIRenameBuffer' },
    dependencies = {
      'kristijanhusak/vim-dadbod-ui',
      'kristijanhusak/vim-dadbod-completion',
    },
    config = function()
      require('myplugins.dadbod').setup()
    end,
  },
  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
}, {})
