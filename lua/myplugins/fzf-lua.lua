require('fzf-lua').setup {
  keymap = {
    fzf = {
      ['ctrl-q'] = 'select-all+accept',
    },
  },
  previewers = {
    builtin = {
      -- Let snacks.image render sharp previews via Ghostty's kitty graphics support.
      -- External image commands run before snacks.image and would force blurry text output.
      snacks_image = {
        enabled = true,
        render_inline = true,
      },
    },
  },
}
