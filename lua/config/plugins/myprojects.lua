local helpers = require('config.plugins.search')

-- Machine-local workspace folders come from NVIM_PROJECT_WORKSPACES (colon-separated),
-- set outside this repo so private paths stay out of it.
local function workspace_dirs()
  local dirs = vim.env.NVIM_PROJECT_WORKSPACES or '~/workspace:~/repos'
  return helpers.existing_dirs(vim.split(dirs, ':', { trimempty = true }))
end

require('myprojects').setup({
  workspaces = workspace_dirs(),
  projects = helpers.existing_dirs({
    '~/.config/nvim',
    '~/Documents/myNotes',
  }),
  close_open_buffers = true,
})
