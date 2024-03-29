-- if vim.g.snippets ~= "luasnip" then
--   return
-- end

local ls = require("luasnip")

require('luasnip.loaders.from_vscode').lazy_load()
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })

ls.config.setup {}

vim.cmd([[command! LuaSnipEdit :lua require("luasnip.loaders.from_lua").edit_snippet_files()]])

local types = require("luasnip.util.types")
ls.config.set_config({
  history = true,                            --keep around last snippet local to jump back
  updateevents = "TextChanged,TextChangedI", --update changes as you type
  enable_autosnippets = true,
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "●", "GruvboxOrange" } },
      },
    },
    -- [types.insertNode] = {
    -- 	active = {
    -- 		virt_text = { { "●", "GruvboxBlue" } },
    -- 	},
    -- },
  },
})

-- <c-k> is my expansion key
-- this will expand the current item or jump to the next item within the snippet
vim.keymap.set({ "i", "s" }, "<C-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

-- <C-j> is my jump backwards key.
-- this always moves to the previous item within the snippet
vim.keymap.set({ "i", "s" }, "<C-j>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

-- <c-l> is selecting within a list of options.
-- This is useful for choice nodes (introduced in the forthcoming episode 2)
vim.keymap.set("i", "<c-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

vim.keymap.set("n", "<Leader><CR>", "<cmd>LuaSnipEdit<cr>", { silent = true, noremap = true })
vim.cmd([[autocmd BufEnter */snippets/*.lua nnoremap <silent> <buffer> <CR> /-- End Refactoring --<CR>O<Esc>O]])

-- shorcut to source my luasnips file again, which will reload my snippets, need to change the path accordingly
-- vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>")
