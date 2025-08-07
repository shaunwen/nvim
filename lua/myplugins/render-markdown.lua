require('render-markdown').setup({
    heading = { backgrounds = {} },
    checkbox = {
        enabled = true,
        render_modes = false,
        bullet = false,
        right_pad = 1,
        unchecked = {
            icon = '⬜',
            -- icon = '󰄱',
            highlight = 'RenderMarkdownUnchecked',
        },
        checked = {
            icon = '✅',
            -- icon = '󰄲',
            highlight = 'RenderMarkdownChecked',
        },
        custom = {
            todo = {
                raw = '[-]',
                rendered = '󰥔 ',
                highlight = 'RenderMarkdownTodo',
                scope_highlight = nil
            },
            important = {
                raw = '[~]',
                rendered = '󰓎 ',
                highlight = 'DiagnosticWarn',
            },
        },
    },
    pipe_table = {
        filler = '',
    }
})

-- Optional: Make unchecked box green too, if desired, or keep neutral
vim.api.nvim_set_hl(0, 'RenderMarkdownUnchecked', { fg = '#00FF00' }) -- Optional green
-- ✅ does not need highlighting because it's a full-color emoji already
