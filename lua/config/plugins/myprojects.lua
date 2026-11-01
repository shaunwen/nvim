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
    -- Notes vault location is machine-specific; zk's notebook variable is the
    -- single source of truth, with the old path kept as a fallback for
    -- machines that have not set it.
    vim.env.ZK_NOTEBOOK_DIR or '~/Documents/myNotes',
  }),
  close_open_buffers = true,
})
