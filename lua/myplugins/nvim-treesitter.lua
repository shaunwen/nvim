local status, treesitter = pcall(require, "nvim-treesitter.configs")
if (not status) then return end

treesitter.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "markdown" },
    disable = {},
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
    "tsx",
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
    "bash",
    "sql",
    "lua",
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
  }
}
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }

-- Treesitter folding
-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
