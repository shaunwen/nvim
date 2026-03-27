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

require('snacks').setup({
  image = {
    enabled = true,
    formats = image_formats,
  },
})
