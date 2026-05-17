local helpers = require('config.plugins.search')

require('myprojects').setup({
  workspaces = helpers.existing_dirs({
    '~/workspace/projects/work-repos',
    '~/workspace/projects/work-repos/worktrees',
    '~/repo/learning/rust',
    '~/workspace/projects/work-repos/rust',
  }),
  projects = helpers.existing_dirs({
    '~/.config/nvim',
    '~/Documents/myNotes',
  }),
  close_open_buffers = true,
})
