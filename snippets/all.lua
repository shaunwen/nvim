local ls = require('luasnip')

local snip = ls.s
local text = ls.t
local insert = ls.i
local choice = ls.choice_node
local func = ls.function_node

local default_prefix = 'pj'

-- PROJECT_ROOTS is a PATH-like list of project directories, each optionally
-- carrying the trigger prefix for the repos it holds:
--   PROJECT_ROOTS="sp=~/workspace/projects/scalapay-repos:rs=~/repo/learning/rust"
local function project_roots()
  local roots = {}

  for _, entry in ipairs(vim.split(vim.env.PROJECT_ROOTS or '', ':', { trimempty = true })) do
    local prefix, dir = entry:match('^(%w+)=(.+)$')
    dir = vim.fn.expand(dir or entry)

    if vim.fn.isdirectory(dir) == 1 then
      roots[#roots + 1] = { prefix = prefix or default_prefix, dir = dir }
    end
  end

  return roots
end

local function repo_names(dir)
  local names = {}

  for name, kind in vim.fs.dir(dir) do
    if kind == 'directory' and not vim.startswith(name, '.') then
      names[#names + 1] = name
    end
  end

  table.sort(names)
  return names
end

local snippets = {
  snip({
    trig = 'pwd',
    namr = 'PWD',
    dscr = 'Path to current working directory',
  }, {
    func(function()
      return { vim.fn.getcwd() }
    end, {}),
  }),
  snip({
    trig = 'filename',
    namr = 'Filename',
    dscr = 'Absolute path to file',
  }, {
    func(function()
      return { vim.fn.expand('%:p') }
    end, {}),
  }),
  snip({
    trig = 'signature',
    namr = 'Signature',
    dscr = 'Name and Surname',
  }, {
    text('Shaun Wen'),
    insert(0),
  }),
}

local roots = project_roots()

if #roots > 0 then
  local root_dirs = {}
  for _, root in ipairs(roots) do
    root_dirs[#root_dirs + 1] = text(root.dir)
  end

  snippets[#snippets + 1] = snip({
    trig = 'pjp',
    namr = 'Project root path',
    dscr = 'Project root path (<C-l> cycles through PROJECT_ROOTS)',
  }, #root_dirs == 1 and { root_dirs[1] } or { choice(1, root_dirs) })
end

for _, root in ipairs(roots) do
  for _, name in ipairs(repo_names(root.dir)) do
    local repo_snip = snip({
      trig = root.prefix .. name,
      name = name,
      dscr = vim.fn.fnamemodify(root.dir, ':~'),
    }, {
      text(name),
    })

    snippets[#snippets + 1] = repo_snip
  end
end

return snippets
