local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'morhetz/gruvbox'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
Plug 'terryma/vim-multiple-cursors'
Plug 'godlygeek/tabular'
Plug('ms-jpq/chadtree', { branch = 'chad', ['do'] = vim.fn['python3 -m chadtree deps'] })
Plug('junegunn/fzf', { ['do'] = vim.fn['fzf#install'] })
Plug 'junegunn/fzf.vim'
Plug 'hoob3rt/lualine.nvim'
Plug 'numToStr/Comment.nvim'
Plug 'windwp/nvim-autopairs'

-- language server protocol
Plug 'neovim/nvim-lspconfig'
Plug 'onsails/lspkind-nvim'
Plug 'glepnir/lspsaga.nvim'
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = vim.fn['TSUpdate'] })
Plug 'kyazdani42/nvim-web-devicons'

-- git
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'
Plug 'tommcdo/vim-fubitive'

-- code completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lua'
-- For vsnip users.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'
-- For luasnip
-- Plug 'L3MON4D3/LuaSnip'
-- Plug 'saadparwaiz1/cmp_luasnip'

-- Markdown
Plug('iamcco/markdown-preview.nvim', { ['do'] = vim.fn['mkdp#util#install'] })
Plug 'mickael-menu/zk-nvim'

Plug 'windwp/nvim-ts-autotag'
Plug 'klen/nvim-test'

Plug 'aklt/plantuml-syntax'

-- rust
Plug 'simrat39/rust-tools.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'mfussenegger/nvim-dap'

vim.call('plug#end')
