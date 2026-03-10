# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration using `lazy.nvim` as the plugin manager. The config targets Neovim 0.11+ and uses Lua throughout.

## Architecture

```
~/.config/nvim/
├── init.lua              # Entry point - loads core modules in order
├── lua/
│   ├── core/
│   │   ├── basic.lua     # Editor options (numbers, tabs, clipboard, etc.)
│   │   ├── keymap.lua    # All keybindings with Chinese descriptions
│   │   └── lazy.lua      # lazy.nvim bootstrap and plugin import
│   └── plugins/          # Individual plugin configs (lazy.nvim spec)
└── snippets/             # LuaSnip snippets (JSON format)
```

**Plugin Loading Pattern**: Each file in `lua/plugins/` returns a lazy.nvim spec table. The `lazy.lua` imports all plugins via `{ import = "plugins" }`.

## Key Commands

### Plugin Management
```vim
:Lazy sync        " Install/update/clean plugins
:Lazy clean       " Remove unused plugins
:Lazy profile     " Analyze startup performance
```

### LSP & Formatting
```vim
:Mason            " Open Mason UI to install LSP servers
:LspInfo          " Show attached LSP clients
:NullLsInfo       " Show null-ls sources (formatters)
:TSInstall all    " Install all Treesitter parsers
```

### Diagnostics
```vim
:checkhealth              " Full health check
:checkhealth telescope    " Check Telescope dependencies
```

## Configuration Patterns

### Adding a New Plugin
Create a new file in `lua/plugins/` that returns a lazy.nvim spec:
```lua
---@diagnostic disable: undefined-global
return {
  "author/plugin-name",
  event = "VeryLazy",  -- or cmd, keys, ft for lazy loading
  opts = {
    -- plugin options
  },
}
```

### LSP Server Configuration
LSP servers are configured in `lua/plugins/mason.lua` using Neovim 0.11's `vim.lsp.config()` API:
```lua
vim.lsp.config("server_name", {
  filetypes = { "lua" },
  settings = { ... },
})
```

### Keybinding Convention
All keymaps in `keymap.lua` include Chinese descriptions with source tags:
```lua
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>",
  { desc = "查找文件 (Find Files) --插件(Telescope)" })
```

The Telescope keymaps picker filters to show only keymaps with Chinese descriptions.

## Pre-configured LSP Servers

- `lua_ls` - Lua
- `pyright` - Python
- `clangd` - C/C++
- `racket_langserver` - Racket

## Pre-configured Formatters (via none-ls)

- `stylua` - Lua
- `black` - Python
- `clang-format` - C/C++

## Key Bindings Reference

| Key | Action |
|-----|--------|
| `Space` | Leader key |
| `<leader>ff` | Find files (Telescope) |
| `<leader>fg` | Live grep (Telescope) |
| `<leader>d` | Dashboard |
| `<leader>f` | Format code (LSP) |
| `<leader>bh/bl` | Buffer prev/next |
| `ff` | Hop word jump |
| `jj` | Exit insert mode |
| `<C-s>` | Save file |
| `<C-t>` | Toggle terminal |
| `H` / `L` | Line start / end |
| `tt` / `bb` | Page up / down |
| `<F1>` | Show keymaps (Telescope) |
| `<F2>` | Rename symbol (Lspsaga) |

## Dependencies

Required external tools:
- `git` - Plugin management
- `node` + `npm` - LSP servers
- `gcc` - Treesitter compilation
- `ripgrep` + `fd` - Telescope search (recommended)
