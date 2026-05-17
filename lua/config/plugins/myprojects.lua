local helpers = require('config.plugins.search')

require('myprojects').setup({
  workspaces = helpers.existing_dirs({
    '~/workspace/projects/scalapay-repos',
    '~/workspace/projects/scalapay-repos/worktrees',
    '~/repo/learning/rust',
    '~/workspace/projects/scalapay-repos/rust',
  }),
  projects = helpers.existing_dirs({
    '~/.config/nvim',
    '~/Documents/myNotes',
  }),
  close_open_buffers = true,
})
