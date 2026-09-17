# CLAUDE.md

This repository contains a Neovim 0.12+ configuration managed by `lazy.nvim`.
The primary AI integration is CodeCompanion using Claude Code over ACP (Agent
Client Protocol).

## Structure

```text
~/.config/nvim/
├── init.lua
├── lazy-lock.json
└── lua/
    ├── core/
    │   ├── basic.lua
    │   ├── keymap.lua
    │   └── lazy.lua
    └── plugins/
        ├── codecompanion.lua
        ├── codecompanion/acp_mode.lua
        └── *.lua
```

`init.lua` loads `core.basic`, `core.keymap`, then `core.lazy`. Each top-level
file in `lua/plugins/` returns a lazy.nvim plugin specification.

## Common commands

```vim
:Lazy sync
:Lazy profile
:checkhealth
:Mason
:MasonToolsInstall
:ConformInfo
:LspInfo
:TSUpdate
```

## Conventions

- Put editor-wide options and autocmds in `lua/core/basic.lua`.
- Put user-facing global keymaps in `lua/core/keymap.lua`.
- Buffer-local or plugin-internal mappings may stay in the relevant plugin
  configuration when they depend on plugin state or capabilities.
- Give global mappings a Chinese description, an English translation, and a
  source tag such as `--系统`, `--自定义`, `--LSP`, or `--插件(Name)`.
- Put LSP server definitions and Mason-managed tools in `lua/plugins/mason.lua`.
- Use Neovim's `vim.lsp.config()` and `vim.lsp.enable()` APIs; do not add legacy
  `require("lspconfig").SERVER.setup()` calls.
- Prefer `opts` over a `config` function when the latter only calls
  `require(...).setup(opts)`.
- Do not copy plugin defaults into local configuration unless intentionally
  overriding them.

## LSP and formatting

Configured language servers:

- `lua_ls`
- `pyright`
- `clangd`
- `vtsls` (JavaScript / TypeScript / React; also handles `<script>` in Vue SFCs
  through `@vue/typescript-plugin`)
- `vue_ls`
- `html`
- `cssls`
- `emmet_language_server`
- `jdtls` when a valid JDK/JAVA_HOME is available

Configured formatters:

- `stylua`
- `black`
- `clang-format`
- `google-java-format`
- `sql-formatter`
- `prettier` (JavaScript / TypeScript / React / Vue / HTML / CSS / JSON)
- Conform's built-in `trim_whitespace`

Mason binaries are prepended to `PATH` during startup. Do not hard-code an
executable path as a language runtime home; for Java, use a real JDK root.

## CodeCompanion

CodeCompanion is intentionally Claude-only:

- chat, inline, and command interactions use `claude_code`;
- background interactions are disabled: ACP adapters are not supported there;
- HTTP adapters and other ACP presets are hidden;
- Claude Code owns filesystem, shell, web, rules, skills, and permission logic;
- CodeCompanion does not auto-inject rule files or external MCP servers;
- `Shift-Tab` in a chat buffer cycles Claude ACP permission modes;
- `Ctrl-V` in a chat buffer pastes an image through `img-clip.nvim`;
- pasted images are stored under Neovim's data directory, outside this repo.

Authentication is handled by Claude Code itself. No Anthropic, DeepSeek, or
Tavily API key is read by this repository.

## External requirements

- Git
- Neovim 0.12+
- Node.js and npm
- a C compiler and Tree-sitter CLI
- `ripgrep` and preferably `fd`
- `yazi`
- `pngpaste` on macOS for clipboard images
- a JDK and `JAVA_HOME` for Java/JDTLS
- `claude-agent-acp` and an authenticated Claude Code session
