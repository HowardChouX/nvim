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

### Keymap Binding Rules

**重要原则**：所有快捷键必须统一管理在 `lua/core/keymap.lua` 中，禁止在插件配置文件里直接定义快捷键。

#### 快捷键命名规范

- **系统快捷键**：Vim 原生操作，描述标签使用 `--系统`
- **自定义快捷键**：用户自定义的增强功能，描述标签使用 `--自定义`
- **插件快捷键**：调用插件功能的快捷键，描述标签使用 `--插件(插件名)`

```lua
-- 格式示例
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>",
  { desc = "查找文件 (Find Files) --插件(Telescope)" })
```

#### 描述格式

所有快捷键必须包含中文描述，格式为：`中文描述 (English Description) --类型`

- 类型标签：`--系统`、`--自定义`、`--插件(名称)`
- Telescope 插件会根据描述中的中文来过滤显示快捷键

#### 快捷键分类 (keymap.lua 结构)

1. **基础配置与 Leader** - Leader 键设置、系统级快捷键
2. **插入模式优化** - Insert 模式下的快捷键
3. **窗口与终端** - 终端相关快捷键
4. **常用编辑操作** - 编辑、翻页、保存等
5. **光标移动与模式切换** - 移动、模式切换
6. **文本对象与高级操作** - 文本对象、宏、寄存器
7. **插件快捷键** - 所有插件的快捷键

#### 开发时重载

keymap.lua 配置了自动重载，修改后保存会自动重新加载：
```lua
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "**/keymap.lua",
  callback = function()
    vim.cmd("source ~/.config/nvim/lua/core/keymap.lua")
  end,
})
```

#### 添加新快捷键

在 keymap.lua 的对应分类下添加，遵循现有格式。禁止在插件配置文件中使用 `keys = {}` 或 `vim.keymap.set()` 定义快捷键。

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
