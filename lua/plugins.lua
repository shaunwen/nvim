vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
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
    'phaazon/hop.nvim',
    lazy = true,
  },
  'terryma/vim-multiple-cursors',
  'godlygeek/tabular',
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {}
  },
  'windwp/nvim-autopairs',
  'windwp/nvim-ts-autotag',
  'glepnir/lspsaga.nvim',
  'kyazdani42/nvim-web-devicons',
  { 'nvim-tree/nvim-web-devicons', opts = {} },
  'onsails/lspkind-nvim',

  -- Git related plugins
  'tpope/vim-fugitive',
  'tommcdo/vim-fubitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  'nvim-tree/nvim-tree.lua',
  { 'echasnovski/mini.files',      version = '*' },

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
      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
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
  { 'folke/which-key.nvim',  opts = {} },
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',

  -- Themes
  'morhetz/gruvbox',
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
  { 'numToStr/Comment.nvim', opts = {} },

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
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },
  'ThePrimeagen/harpoon',
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
  -- Markdown
  -- {
  --   'iamcco/markdown-preview.nvim',
  --   build = function() vim.fn['mkdp#util#install']() end,
  -- },
  { 'bullets-vim/bullets.vim' },
  -- markdown preview with clikable links
  { 'jannis-baum/vivify.vim' },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you use the mini.nvim suite
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  --  [markdown markmap]
  --  https://github.com/Zeioth/markmap.nvim
  {
    'Zeioth/markmap.nvim',
    build = 'yarn global add markmap-cli',
    cmd = { 'MarkmapOpen', 'MarkmapSave', 'MarkmapWatch', 'MarkmapWatchStop' },
    opts = {
      html_output = '/tmp/markmap.html', -- (default) Setting a empty string '' here means: [Current buffer path].html
      hide_toolbar = false,              -- (default)
      grace_period = 3600000             -- (default) Stops markmap watch after 60 minutes. Set it to 0 to disable the grace_period.
    },
    config = function(_, opts) require('markmap').setup(opts) end
  },
  {
    'mickael-menu/zk-nvim',
    lazy = true,
  },
  { 'aklt/plantuml-syntax' },
  -- Debug
  'mfussenegger/nvim-dap',
  'rcarriga/nvim-dap-ui',
  -- Lua
  'jbyuki/one-small-step-for-vimkind',
  -- Rust
  'simrat39/rust-tools.nvim',
  -- Node
  'mxsdev/nvim-dap-vscode-js',
  'tpope/vim-abolish',
  'shaunwen/fzf-project',
  'akinsho/toggleterm.nvim',
  'mhartington/formatter.nvim',

  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    'tpope/vim-dadbod',
    opt = true,
    dependencies = {
      'kristijanhusak/vim-dadbod-ui',
      'kristijanhusak/vim-dadbod-completion',
    },
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional 'plugins' for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
}, {})
