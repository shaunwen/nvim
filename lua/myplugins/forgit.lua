require 'forgit'.setup({
  debug = false, -- enable debug logging default path is ~/.cache/nvim/forgit.log
  diff = 'delta', -- you can use `diff`, `diff-so-fancy`
  fugitive = false, -- git fugitive installed
  git_alias = true, -- git command extensions see: Git command alias
  show_result = 'quickfix', -- show cmd result in quickfix or notify

  vsplit = false, -- split forgit window the screen vertically
  shell_mode = true, -- set to true if you using zsh/bash and can not run forgit commands
  height_ratio = 0.9, -- height ratio of floating window when split horizontally
  width_ratio = 0.6, -- width ratio of floating window when split vertically
})
