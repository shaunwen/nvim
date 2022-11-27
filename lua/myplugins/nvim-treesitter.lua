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
    disable = {},
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
