local status, treesitter = pcall(require, "nvim-treesitter.configs")
if (not status) then return end

treesitter.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "markdown" },
    -- disable = {},
    disable = function()
      return vim.b.large_buf
    end,
  },
  indent = {
    enable = true,
    disable = {
      -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1136
      "python",
    },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "<c-k>",
      scope_incremental = "<enter>",
      node_decremental = "<c-j>",
    },
  },
  ensure_installed = {
    "c",
    "toml",
    "go",
    "rust",
    "python",
    "json",
    "yaml",
    "html",
    "css",
    "scss",
    "javascript",
    "typescript",
    "tsx",
    "bash",
    "sql",
    "lua",
    'vimdoc',
    "vim",
    "markdown",
    "markdown_inline",
    "gitignore",
    "dockerfile",
    "dot",
    "java",
    "bibtex",
    "latex",
  },
  autotag = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['ai'] = '@conditional.outer',
        ['ii'] = '@conditional.inner',
        ['al'] = '@loop.outer',
        ['il'] = '@loop.inner',
        ['at'] = '@comment.outer',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }

-- avoid collapse all sections when loading a file
vim.opt.foldlevelstart = 99

-- Treesitter folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
