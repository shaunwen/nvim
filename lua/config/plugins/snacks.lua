local image_formats = {
  'png',
  'jpg',
  'jpeg',
  'gif',
  'bmp',
  'webp',
  'tiff',
  'heic',
  'avif',
  'mp4',
  'mov',
  'avi',
  'mkv',
  'webm',
  'pdf',
  'icns',
  'svg',
}

-- Snacks only knows kitty, ghostty, wezterm, tmux and zellij, so Rio is treated
-- as image-incapable and previews fall back to chafa. Rio reports itself as
-- "Rio 0.5.26". Its docs claim unicode placeholder support, but placeholders
-- render blank, so use direct placement as WezTerm does.
table.insert(require('snacks.image.terminal').envs(), 1, {
  name = 'rio',
  terminal = 'rio',
  env = { TERM_PROGRAM = 'rio', TERM = 'rio' },
  supported = true,
  placeholders = false,
})

require('snacks').setup({
  image = {
    enabled = true,
    formats = image_formats,
  },
})
