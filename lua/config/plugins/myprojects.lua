local helpers = require('config.plugins.search')

-- Machine-local workspace folders come from NVIM_PROJECT_WORKSPACES (colon-separated),
-- set outside this repo so private paths stay out of it.
local function workspace_dirs()
  local dirs = vim.env.NVIM_PROJECT_WORKSPACES or '~/workspace:~/repos'
  return helpers.existing_dirs(vim.split(dirs, ':', { trimempty = true }))
end

-- Extra machine-local projects (e.g. a second notes vault) come from
-- NVIM_PROJECT_DIRS (colon-separated), set outside this repo.
local function extra_project_dirs()
  return vim.split(vim.env.NVIM_PROJECT_DIRS or '', ':', { trimempty = true })
end

require('myprojects').setup({
  workspaces = workspace_dirs(),
  projects = helpers.existing_dirs({
    '~/.config/nvim',
    -- Notes vault location is machine-specific; zk's notebook variable is the
    -- single source of truth, with the old path kept as a fallback for
    -- machines that have not set it.
    vim.env.ZK_NOTEBOOK_DIR or '~/Documents/myNotes',
    unpack(extra_project_dirs()),
  }),
  close_open_buffers = true,
})
