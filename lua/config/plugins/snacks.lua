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
-- as image-incapable and previews fall back to chafa.
--
-- Placeholders, not direct placement: a direct placement stays painted at the
-- grid position it was made at until an explicit delete, so images from
-- previously viewed files pile up. Placeholder cells die with Neovim's redraw.
-- Needs Rio >= 0.5.27 (rio#1891).
table.insert(require('snacks.image.terminal').envs(), 1, {
  name = 'rio',
  terminal = 'rio',
  env = { TERM_PROGRAM = 'rio', TERM = 'rio' },
  supported = true,
  placeholders = true,
})

require('snacks').setup({
  image = {
    enabled = true,
    formats = image_formats,
  },
})
