local function is_ghostty()
  if vim.env.TMUX ~= nil then
    local out = vim.fn.system { 'tmux', 'display-message', '-p', '#{client_termname}' }
    return vim.v.shell_error == 0 and out:lower():match 'ghostty' ~= nil
  end

  return vim.env.TERM_PROGRAM == 'ghostty'
end

local ghostty = is_ghostty()

local image_extensions = nil
if not ghostty then
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
  keymap = {
    fzf = {
      ['ctrl-q'] = 'select-all+accept',
    },
  },
  previewers = {
    builtin = {
      -- External image commands run before snacks.image, so only enable them outside Ghostty.
      extensions = image_extensions,
      snacks_image = {
        enabled = ghostty,
        render_inline = ghostty,
      },
    },
  },
}
