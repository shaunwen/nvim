require('fzf-lua').setup {
  keymap = {
    fzf = {
      ['ctrl-q'] = 'select-all+accept',
    },
  },
  previewers = {
    builtin = {
      -- use chafa for real image files
      extensions = {
        ['png'] = { 'chafa', '--size=80x40', '--format=symbols', '{file}' },
        ['jpg'] = { 'chafa', '--size=80x40', '--format=symbols', '{file}' },
        ['jpeg'] = { 'chafa', '--size=80x40', '--format=symbols', '{file}' },
        ['gif'] = { 'chafa', '--size=80x40', '--animate=false', '{file}' },
        ['webp'] = { 'chafa', '--size=80x40', '--format=symbols', '{file}' },
        ['svg'] = { 'chafa', '--size=80x40', '{file}' },
      },
    },
  },
}
