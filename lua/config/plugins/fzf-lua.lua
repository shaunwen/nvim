local kitty = vim.env.TERM_PROGRAM == 'ghostty'
  or vim.env.TERM_PROGRAM == 'WezTerm'
  or vim.env.TERM_PROGRAM == 'Kitty'

local image_extensions = nil
if not kitty then
  image_extensions = {
    ['png'] = { 'chafa', '--size=80x40', '--format=symbols', '{file}' },
    ['jpg'] = { 'chafa', '--size=80x40', '--format=symbols', '{file}' },
    ['jpeg'] = { 'chafa', '--size=80x40', '--format=symbols', '{file}' },
    ['gif'] = { 'chafa', '--size=80x40', '--animate=false', '{file}' },
    ['webp'] = { 'chafa', '--size=80x40', '--format=symbols', '{file}' },
    ['svg'] = { 'chafa', '--size=80x40', '{file}' },
  }
end

require('fzf-lua').setup {
  files = {
    hidden = false,
  },
  blines = {
    fzf_colors = {
      ['hl'] = '-1:reverse',
      ['hl+'] = '-1:reverse',
    },
  },
  keymap = {
    builtin = {
      ['<C-f>'] = 'preview-page-down',
      ['<C-b>'] = 'preview-page-up',
    },
    fzf = {
      ['ctrl-q'] = 'select-all+accept',
    },
  },
  git = {
    status = {
      keymap = {
        fzf = {
          ['ctrl-f'] = 'preview-page-down',
          ['ctrl-b'] = 'preview-page-up',
        },
      },
    },
    diff = {
      keymap = {
        fzf = {
          ['ctrl-f'] = 'preview-page-down',
          ['ctrl-b'] = 'preview-page-up',
        },
      },
    },
    commits = {
      keymap = {
        fzf = {
          ['ctrl-f'] = 'preview-page-down',
          ['ctrl-b'] = 'preview-page-up',
        },
      },
    },
    bcommits = {
      keymap = {
        fzf = {
          ['ctrl-f'] = 'preview-page-down',
          ['ctrl-b'] = 'preview-page-up',
        },
      },
    },
  },
  hls = {
    cursorline = 'Visual',
    search = 'IncSearch',
  },
  fzf_colors = {
    ['hl'] = { 'fg', 'FzfLuaFzfMatch' },
    ['hl+'] = { 'fg', 'FzfLuaFzfMatchCurrent', 'bold' },
    ['fg+'] = { 'fg', 'Normal' },
    ['bg+'] = { 'bg', 'Visual' },
  },
  previewers = {
    builtin = {
      -- External image commands run before snacks.image, so only enable them outside Kitty-compatible terminals.
      extensions = image_extensions,
      snacks_image = {
        enabled = kitty,
        render_inline = kitty,
      },
    },
  },
}
