-- TERM_PROGRAM names the launching app, which is not the terminal on the other
-- end of the pty under a multiplexer. Snacks queries the terminal itself.
local ok, supported = pcall(function()
  return Snacks.image.supports_terminal()
end)
local kitty = ok and supported

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
  winopts = {
    preview = {
      delay = 100,
      wrap = true,
    },
  },
  files = {
    hidden = false,
    -- .env files are usually gitignored, so a second fd re-adds them past the
    -- ignore rules; awk drops the duplicates when a .env* file is not ignored.
    -- fzf-lua's alt-h/alt-i toggles insert a flag after the first word, so the
    -- command must start with `fd`, and strip every occurrence of it. Both
    -- passes carry --hidden so alt-h drives the .env pass too; with it
    -- stripped, fd rejects the dot-only glob, so that error is discarded.
    cmd = table.concat({
      'fd --type f --hidden --exclude .git',
      "| { cat; fd --type f --hidden -I --glob '.env*' --exclude .git --exclude node_modules --exclude dist 2>/dev/null; }",
      "| awk '!seen[$0]++'",
    }, ' '),
  },
  blines = {
    fzf_colors = {
      ['hl'] = '-1:reverse',
      ['hl+'] = '-1:reverse',
    },
  },
  keymap = {
    builtin = {
      true,
      ['<C-f>'] = 'preview-page-down',
      ['<C-b>'] = 'preview-page-up',
    },
    fzf = {
      true,
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
