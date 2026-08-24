# Neovim Configuration

Personal Neovim setup built around `lazy.nvim` with plugin specs grouped by domain and plugin configuration isolated from startup.

## Goals

- Keep startup work small and predictable.
- Make plugin ownership obvious.
- Keep plugin-specific keymaps and lazy-loading triggers close to the plugin spec.
- Make the config easy to extend without growing one large `plugins.lua`.

## Structure

```text
.
|-- init.lua
|-- lua
|   |-- config
|   |   |-- autocmds.lua
|   |   |-- keymaps.lua
|   |   |-- lazy.lua
|   |   |-- options.lua
|   |   `-- plugins
|   |-- plugins
|   |   |-- coding.lua
|   |   |-- completion.lua
|   |   |-- debug.lua
|   |   |-- editor.lua
|   |   |-- git.lua
|   |   |-- lsp.lua
|   |   |-- notes.lua
|   |   |-- search.lua
|   |   |-- terminal.lua
|   |   |-- ui.lua
|   |   `-- lang
|   `-- autosave.lua
`-- snippets
    |-- all.lua
    |-- go.lua
    |-- javascript.lua
    |-- lua.lua
    |-- markdown.lua
    |-- plantuml.lua
    |-- python.lua
    |-- sh.lua
    `-- yaml.lua
```

### Startup flow

`init.lua` only loads four modules:

1. `config.options`
2. `config.lazy`
3. `config.keymaps`
4. `config.autocmds`

That keeps bootstrap logic small and prevents plugin config from being eagerly required during startup.

## How plugins are organized

### `lua/plugins/*.lua`

These files define plugin specs for `lazy.nvim`.

Each spec is responsible for:

- declaring the plugin
- defining lazy-loading triggers such as `keys`, `cmd`, `ft`, and `event`
- pointing to its config module when needed

Grouped files currently include:

- `ui.lua`: colorscheme, statusline, indent guides, icons, UI helpers
- `search.lua`: Telescope, `fzf-lua`, Harpoon, Flash, project switching
- `lsp.lua`: LSP, Mason, LazyDev, Lspsaga
- `completion.lua`: Blink, LuaSnip, Copilot, Lspkind
- `coding.lua`: Treesitter, Comment, Autopairs, Refactoring, Conform, Dadbod
- `debug.lua`: `nvim-dap` and related debug UI
- `terminal.lua`: Toggleterm
- `notes.lua`: markdown, zk, markmap, note-related helpers
- `git.lua`: Fugitive, Gitsigns, related Git tooling
- `lang/rust.lua`: Rust-specific setup

### `lua/config/plugins/*.lua`

These files contain plugin setup logic only.

They should not be loaded directly from `init.lua`.
They are loaded by the owning plugin spec when the plugin itself is loaded.

## Current navigation model

- File browsing: `mini.files`
- Search and picker workflows: Telescope and `fzf-lua`
- `nvim-tree` is intentionally removed

The intent is:

- use Telescope for broad search and navigation
- use `fzf-lua` for fast fuzzy workflows already baked into this setup
- use `mini.files` for directory and file browsing

## Core design rules

- Keep `config/keymaps.lua` for editor-level keymaps only.
- Put plugin-owned mappings in the relevant plugin spec.
- Prefer `opts` for simple plugin setup.
- Use `config = function()` only when the plugin needs real custom logic.
- Use `init = function()` for globals that must exist before the plugin loads.
- Avoid top-level `require(...)` calls that pull plugin config into startup.

## Snippets

LuaSnip is configured in `lua/config/plugins/luasnip.lua` and exposed through Blink's
`snippets` source, so snippets are fuzzy-matched in the completion menu alongside LSP results.

### File convention

Snippets live in `snippets/`, loaded by the `from_lua` loader.

**The filename is the filetype.** `snippets/go.lua` provides Go snippets; `snippets/all.lua`
provides snippets for every buffer. Each file returns a flat list:

```lua
-- snippets/go.lua
return {
  snip('typei', { ... }),
  snip('types', { ... }),
}
```

Files that build their list incrementally end with `return snippets, autosnippets`.

A file returning a table **keyed by filetype** is silently ignored - the loader passes the
returned value straight to `ls.add_snippets(<filename>, ...)`, which iterates with `ipairs`,
and a table with only string keys has no array part. No error is raised; the snippets simply
never register.

### Keymaps

| Key | Action |
| --- | --- |
| `<Tab>` | expand snippet, or jump to next placeholder |
| `<S-Tab>` | jump to previous placeholder |
| `<C-l>` | cycle the current choice node |
| `<Leader><CR>` | `:LuaSnipEdit` - open a snippet file |

### Project-root snippets

`snippets/all.lua` generates one snippet per repository found in the project roots named by
the `PROJECT_ROOTS` environment variable. It is a PATH-like list whose entries optionally
carry the trigger prefix for the repos in that root:

```sh
export PROJECT_ROOTS="sp=$HOME/workspace/projects/scalapay-repos:rs=$HOME/repo/learning/rust"
```

Both `~` and `$VAR` forms are expanded. An entry with no `prefix=` falls back to `pj`.
Nonexistent directories are skipped silently, so a stale entry means fewer snippets rather
than a startup error.

This yields:

- `<prefix><repo-name>` for every repository, inserting the bare repo name. Blink fuzzy-matches
  the trigger, so `spapi` reaches `myorg-api`, and the `sp` prefix is stripped on
  accept.
- `pjp` for the root paths themselves. With several roots it expands to the first and `<C-l>`
  cycles through the rest.

Roots are scanned once when snippets load, so a newly cloned repository needs a Neovim restart.

### Where to define `PROJECT_ROOTS`

Define it in `~/.zshenv`, **not** `~/.zshrc`, and keep exactly one copy.

zsh sources `.zshrc` only for interactive shells. Neovide on macOS resolves its environment by
spawning a login, non-interactive shell, which reads `.zshenv` and `.zprofile` but skips
`.zshrc`. Terminal shells read `.zshenv` as well, so a single definition there covers both:

| Defined in | Terminal Neovim | Neovide (GUI) |
| --- | --- | --- |
| `.zshrc` | works | **not set** |
| `.zshenv` | works | works |

## Profiling

Useful commands:

```sh
nvim --headless --startuptime /tmp/nvim-startup.log +qa
tail -n 40 /tmp/nvim-startup.log
```

Inside Neovim:

```vim
:Lazy
:Lazy profile
```

## Customization guide

### Add a new plugin

1. Choose the appropriate file under `lua/plugins/`.
2. Add the plugin spec with its lazy-loading trigger.
3. If the plugin needs configuration, add a module under `lua/config/plugins/`.
4. Reference that module from the plugin spec.

### Add a new language-specific plugin

Put it under `lua/plugins/lang/` when it is specific to one language or ecosystem.

### Add a snippet

Add it to `snippets/<filetype>.lua`, creating the file if it does not exist. Return a flat list;
see [Snippets](#snippets) for the shape the loader expects.

### Add a project root

Append a `prefix=dir` entry to `PROJECT_ROOTS` in `~/.zshenv`, then **start a new shell** and
restart Neovim from it.

### Add a new plugin keymap

Prefer adding it to the plugin spec using `keys = { ... }` so the keymap also acts as a lazy-loading trigger.

## Notes

- Local snippets live under `snippets/`; see [Snippets](#snippets).
- `lazy-lock.json` tracks plugin versions managed by `lazy.nvim`.
- `lua/autosave.lua` exists outside the grouped plugin layout and can be folded into the plugin structure later if needed.
