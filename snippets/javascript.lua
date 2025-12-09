local ls = require('luasnip') --{{{
local s = ls.s
local i = ls.i
local t = ls.t

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep

local snippets, autosnippets = {}, {} --}}}

local group = vim.api.nvim_create_augroup('Javascript Snippets', { clear = true })
local file_pattern = '*.js'

local function cs(trigger, nodes, opts) --{{{
  local snippet = s(trigger, nodes)
  local target_table = snippets

  local pattern = file_pattern
  local keymaps = {}

  if opts ~= nil then
    -- custom pattern
    if opts.pattern then
      pattern = opts.pattern
    end

    -- if opts is a string
    if type(opts) == 'string' then
      if opts == 'auto' then
        target_table = autosnippets
      else
        table.insert(keymaps, { 'i', opts })
      end
    end

    -- if opts is a table
    if type(opts) == 'table' then
      for _, keymap in ipairs(opts) do
        if type(keymap) == 'string' then
          table.insert(keymaps, { 'i', keymap })
        else
          table.insert(keymaps, keymap)
        end
      end
    end

    -- set autocmd for each keymap
    if opts ~= 'auto' then
      for _, keymap in ipairs(keymaps) do
        vim.api.nvim_create_autocmd('BufEnter', {
          pattern = pattern,
          group = group,
          callback = function()
            vim.keymap.set(keymap[1], keymap[2], function()
              ls.snip_expand(snippet)
            end, { noremap = true, silent = true, buffer = true })
          end,
        })
      end
    end
  end

  table.insert(target_table, snippet)
end --}}}

-- Old Style --

-- Helper to create fresh nodes for if_fmt to avoid deepcopy issues
local function get_if_fmt_arg() --{{{
  return {
    i(1, ''), -- indent / prefix
    i(2, 'LHS'),
    c(3, { -- operator choice, not editable
      t('==='),
      t('<'),
      t('>'),
      t('<='),
      t('>='),
      t('!=='),
    }),
    i(4, 'RHS'),
    i(5, '//TODO:'),
  }
end

local if_fmt_1 = fmt(
  [[
{}if ({} {} {}) {};
    ]],
  get_if_fmt_arg()
)
local if_fmt_2 = fmt(
  [[
{}if ({} {} {}) {{
  {};
}}
    ]],
  get_if_fmt_arg()
)

local if_snippet = s(
  { trig = 'IF', regTrig = false, hidden = true },
  c(1, {
    if_fmt_1,
    if_fmt_2,
  })
) --}}}

-- function snippet: use factory to avoid deepcopy
local function get_function_fmt() --{{{
  return fmt(
    [[
function {}({}) {{
  {}
}}
    ]],
    {
      i(1, 'myFunc'),
      i(2, 'arg'),
      i(3, '//TODO:'),
    }
  )
end

local function_snippet = s(
  { trig = 'f[un]?', regTrig = true, hidden = true },
  { get_function_fmt() }
)
local function_snippet_func = s({ trig = 'func' }, { get_function_fmt() }) --}}}

-- dynamic nodes: inner snippet_nodes must use `sn(1, ...)` instead of `sn(nil, ...)`
local short_hand_if_fmt = fmt( --{{{
  [[
if ({}) {}
{}
    ]],
  {
    d(1, function(_, snip)
      return sn(nil, t(snip.captures[1]))
    end),
    d(2, function(_, snip)
      return sn(nil, t(snip.captures[2]))
    end),
    i(3, ''),
  }
)
local short_hand_if_statement = s(
  { trig = 'if[>%s](.+)>>(.+)\\', regTrig = true, hidden = true },
  { short_hand_if_fmt }
)

local short_hand_if_statement_return_shortcut = s(
  { trig = '(if[>%s].+>>)[r<]', regTrig = true, hidden = true },
  {
    f(function(_, snip)
      return snip.captures[1]
    end),
    t('return '),
  }
) --}}}
table.insert(autosnippets, if_snippet)
table.insert(autosnippets, short_hand_if_statement)
table.insert(autosnippets, short_hand_if_statement_return_shortcut)
table.insert(snippets, function_snippet)
table.insert(snippets, function_snippet_func)

-- Begin Refactoring --

-- fori JS For Loop snippet (safe with latest LuaSnip) {{{
cs('fori', {
  fmt(
    [[
for (let {} = 0; {} < {}; {}++) {{
  {}
}}

{}
    ]],
    {
      -- loop variable
      i(1, 'i'),
      -- condition var
      rep(1),
      -- loop bound: either a number or array.length
      c(2, {
        i(3, 'num'),
        sn(nil, { i(3, 'arr'), t('.length') }),
      }),
      -- increment var
      rep(1),
      -- body
      i(4, '// TODO:'),
      i(5),
    }
  ),
}) --}}}

cs( -- [while] JS While Loop snippet{{{
  'while',
  {
    fmt(
      [[
while ({}) {{
  {}
}}
  ]],
      {
        i(1, ''),
        i(2, '// TODO:'),
      }
    ),
  }
) --}}}

cs('cl', { t('console.log('), i(1, ''), t(')') }, { 'jcl', 'jj' }) -- console.log

-- End Refactoring --

return snippets, autosnippets
