# Neovim Configuration

一个现代化的 Neovim 0.11+ 配置，使用 Lua 编写，以 AI 编程助手为核心，集成 CodeCompanion 和完整的 MCP 支持。

## 目录

- [快速开始](#快速开始)
- [插件列表](#插件列表)
- [核心插件详解](#核心插件详解)
- [快捷键速查表](#快捷键速查表)
- [依赖项](#依赖项)
- [环境变量](#环境变量)
- [文件结构](#文件结构)

---

## 快速开始

```bash
# 克隆配置（如果是新安装）
git clone git@github.com:HowardChouX/easynvim.git ~/.config/nvim

# 启动 Neovim（lazy.nvim 会自动安装插件）
nvim

# 安装 LSP 服务器
:Mason

# 安装 Treesitter 语法解析器
:TSInstall all
```

---

## 插件列表

### 插件管理器
| 插件 | 描述 |
|------|------|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | 现代化插件管理器，支持懒加载和并发安装 |

### LSP 和自动补全
| 插件 | 描述 |
|------|------|
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP 客户端配置 |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | LSP/格式化器安装管理 |
| [blink.nvim](https://github.com/saghen/blink.cmp) | AI 驱动的代码补全引擎 |

### AI 编程助手
| 插件 | 描述 |
|------|------|
| [codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim) | AI 聊天编程助手，支持 MCP |

### 文件搜索和模糊查找
| 插件 | 描述 |
|------|------|
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | 模糊查找和搜索 |
| [yazi.nvim](https://github.com/mikavilpas/yazi.nvim) | 终端文件管理器集成 |

### 语法高亮和文本对象
| 插件 | 描述 |
|------|------|
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | 语法高亮和解析 |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Markdown 渲染增强 |

### 代码编辑增强
| 插件 | 描述 |
|------|------|
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | 自动补全括号对 |
| [lspsaga.nvim](https://github.com/nvimdev/lspsaga.nvim) | 增强 LSP 功能的 UI 界面 |
| [vim-visual-multi](https://github.com/mg979/vim-visual-multi) | 多光标编辑 |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | 代码格式化 |

### UI 增强
| 插件 | 描述 |
|------|------|
| [aerial.nvim](https://github.com/stevearc/aerial.nvim) | 代码大纲/符号导航 |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | 状态栏 |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | 缓冲区标签页 |
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | 颜色主题 |
| [noice.nvim](https://github.com/folke/noice.nvim) | 现代化通知和命令栏 UI |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | 缩进线 |
| [dashboard-nvim](https://github.com/nvimdev/dashboard-nvim) | 启动画面 |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | 快捷键提示窗口 |
| [hop.nvim](https://github.com/smoka7/hop.nvim) | 快速跳转/光标移动 |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) | 嵌入式终端 |

---

## 核心插件详解

### 1. lazy.nvim - 插件管理器

**功能**: 现代 Lua 插件管理器，支持懒加载、并发安装、自动更新。

**用法**:
```vim
:Lazy sync        " 安装/更新/清理插件
:Lazy clean       " 移除未使用插件
:Lazy profile     " 分析启动性能
:Lazy health      " 检查插件健康状态
```

---

### 2. nvim-lspconfig - LSP 配置

**功能**: Neovim 内置 LSP 客户端的配置，提供快速的 LSP 服务器设置。

**预配置 LSP 服务器**:
- `lua_ls` - Lua
- `pyright` - Python
- `clangd` - C/C++
- `sqls` - SQL

**用法**:
```vim
:LspInfo              " 显示已连接的 LSP 客户端
:LspRestart           " 重启当前缓冲区的 LSP 服务器
```

---

### 3. mason.nvim - 工具安装器

**功能**: 统一管理 LSP 服务器、格式化器等开发工具的安装。

**用法**:
```vim
:Mason                " 打开 Mason UI
:MasonInstall all     " 安装所有配置的服务器
:MasonInstall pyright " 安装特定服务器
```

**自动安装的工具**:

| 类型 | 工具 |
|------|------|
| LSP 服务器 | lua_ls, pyright, clangd, sqls |
| 格式化器 | stylua, black, clang-format, sql-formatter |

---

### 4. blink.nvim - AI 代码补全

**功能**: 轻量级、高性能的 AI 代码补全插件，支持语义补全、片段（snippets）和 LSP 补全集成。

**快捷键**:
| 快捷键 | 功能 |
|--------|------|
| `<Tab>` | 选择下一个补全项 / 展开代码片段 |
| `<S-Tab>` | 选择上一个补全项 |
| `<Enter>` | 确认补全 |
| `<Up>/<Down>` | 上下选择补全项 |

**特性**:
- 自动括号补全 (`auto_brackets`)
- 函数签名显示 (`signature`)
- 代码片段支持 (friendly-snippets)
- 命令行补全集成

---

### 5. lspsaga.nvim - LSP UI 增强

**功能**: 增强 LSP 的用户界面，提供符号查找、代码操作、悬停文档、诊断显示等功能。

**快捷键**:
| 快捷键 | 功能 |
|--------|------|
| `gd` | 跳转到定义 (Go to Definition) |
| `<F2>` | 重命名符号 (Rename) |
| `<leader>n` | 跳转到下一个诊断信息 |
| `<leader>p` | 跳转到上一个诊断信息 |

**特性**:
- 符号查找器 (`finder`)
- 悬浮窗口信息 (`hover`, `doc`)
- 代码操作 (`code_action`)
- 诊断跳转

---

### 6. codecompanion.nvim - AI 编程助手

**功能**: 强大的 AI 编程助手，支持多种 AI 模型和 MCP 工具集成，可进行聊天、代码编辑、文件操作等。

**快捷键**:
| 快捷键 | 功能 |
|--------|------|
| `<leader>cc` | 打开/关闭 CodeCompanion 聊天窗口 |
| `v` + `ga` | 将选中文本添加到聊天 |
| `<CR>` | 发送消息（聊天窗口内） |
| `<C-c>` | 关闭聊天窗口 |
| `q` | 停止生成 |
| `gr` | 重新生成响应 |
| `gc` | 插入代码块 |
| `gy` | 复制代码 |

**MCP 服务器集成**:
| 服务器 | 功能 |
|--------|------|
| filesystem | 文件系统操作（读/写/删除文件） |
| memory | 持久化记忆存储 |
| sequential-thinking | 复杂推理和思考能力 |
| tavily | AI 优化的网络搜索 |
| fetch | HTTP 请求/网页内容获取 |
| time | 时间相关工具 |

**触发前缀**:
| 前缀 | 功能 |
|------|------|
| `\` | ACP 斜杠命令 (如 `\help`) |
| `#` | 发送编辑器上下文 (如 `#buffer`) |
| `/` | 普通斜杠命令 |
| `@` | 工具调用 (如 `@filesystem`) |

---

### 7. telescope.nvim - 模糊查找

**功能**: 强大的模糊查找和搜索工具，支持文件搜索、全局搜索、缓冲区搜索等。

**快捷键**:
| 快捷键 | 功能 |
|--------|------|
| `<leader>ff` | 查找文件 (Find Files) |
| `<leader>fg` | 全局搜索 (Live Grep) |
| `<leader>fb` | 查找缓冲区 |
| `<leader>fh` | 查找帮助标签 |
| `<F1>` | 显示所有快捷键列表 |
| `<leader>rf` | 查找最近文件 |

**特性**:
- 支持 ripgrep 和 fd
- 自定义 entry_maker，按描述排序
- UI Select 集成

---

### 8. aerial.nvim - 代码大纲

**功能**: 显示代码结构大纲（类、函数、方法等），支持 Treesitter 和 LSP 提供者。

**快捷键**:
| 快捷键 | 功能 |
|--------|------|
| `<leader>t` | 打开/关闭代码大纲 |
| `j/k` | 上/下一个符号 |
| `<CR>` | 跳转到选中符号 |
| `<Tab>` / `o` | 展开/折叠树 |
| `q` | 关闭大纲窗口 |

**显示的符号类型**:
- Class, Constructor, Enum
- Function, Interface, Method
- Module, Struct, Variable

---

### 9. yazi.nvim - 文件管理器

**功能**: 集成 yazi 终端文件管理器，提供快速的文件浏览和操作。

**快捷键**:
| 快捷键 | 功能 |
|--------|------|
| `<leader>e` | 打开 Yazi 文件管理器 |
| `<f1>` | 显示帮助 |
| `<c-v>` | 垂直分屏打开 |
| `<c-x>` | 水平分屏打开 |
| `<c-t>` | 在新标签页打开 |
| `<c-s>` | 在目录中搜索 |
| `<c-y>` | 复制选中文件相对路径 |
| `<tab>` | 循环打开缓冲区 |
| `<c-q>` | 发送到 quickfix 列表 |

---

### 10. nvim-treesitter - 语法解析

**功能**: 提供语法高亮、文本对象、缩进等基于 Treesitter 的功能。

**用法**:
```vim
:TSInstall all          " 安装所有语法解析器
:TSInstall python       " 安装特定语言解析器
:TSUpdate               " 更新已安装的解析器
:TSInstallSync lua      " 同步安装（阻塞式）
```

**自动安装的解析器**:
lua, vim, vimdoc, toml, python, cpp, c, json, yaml, bash, markdown, markdown_inline, html, css, javascript, typescript, tsx, regex, go, rust, query

---

### 11. render-markdown.nvim - Markdown 渲染

**功能**: 增强 Markdown 文件的渲染效果，包括标题样式、代码块、表格、复选框等。

**特性**:
- 标题图标渲染 (󰲡 - 󰲫)
- 代码块语法高亮和语言标签
- GitHub 风格表格边框
- 复选框渲染 (●/○/◆/◇)
- Callout 标注支持 (NOTE, TIP, WARNING 等)
- LaTeX 和 HTML 支持

---

### 12. nvim-autopairs - 自动括号

**功能**: 自动补全括号、引号等配对符号。

**用法**: 在插入模式下输入 `(`, `[`, `{`, `"`, `'` 等，会自动补全配对。

---

### 13. vim-visual-multi - 多光标编辑

**功能**: 强大的多光标编辑功能，类似于 VS Code 的多光标。

**快捷键**:
| 快捷键 | 功能 |
|--------|------|
| `<C-n>` | 选中光标下的单词（继续按可多选） |
| `<C-M-Up>` | 在上方添加光标 |
| `<C-M-Down>` | 在下方添加光标 |
| `<C-M-n>` | 全选所有匹配项 |
| `n` | 跳到下一个匹配项 |
| `Q` | 移除当前光标/区域 |
| `u` | 撤销 |
| `<C-r>` | 重做 |

---

### 14. conform.nvim - 代码格式化

**功能**: 轻量级代码格式化，支持多种语言和格式化器。

**快捷键**:
| 快捷键 | 功能 |
|--------|------|
| `<leader>ft` | 格式化当前文件 |

**按语言配置的格式化器**:
| 语言 | 格式化器 |
|------|----------|
| Lua | stylua |
| Python | black |
| C/C++ | clang-format |
| SQL | sql-formatter |

---

### 15. noice.nvim - 通知 UI

**功能**: 现代化通知和命令栏 UI，替代默认的 `messages`。

**快捷键**:
| 快捷键 | 功能 |
|--------|------|
| `<leader>dn` | 关闭通知 (Dismiss Notification) |

**特性**:
- 浮动通知窗口
- 命令行弹出窗口
- LSP 进度显示
- 签名帮助悬浮

---

### 16. lualine.nvim - 状态栏

**功能**: 轻量级、可定制的状态栏。

**显示内容**:
- 模式 (mode)
- Git 分支和差异
- 文件名
- LSP 客户端数量
- 文件大小
- 编码
- 文件类型
- 进度和位置

---

### 17. bufferline.nvim - 缓冲区标签

**功能**: 显示缓冲区标签页，类似 IDE 的标签栏。

**快捷键**:
| 快捷键 | 功能 |
|--------|------|
| `<leader>bh` | 上一个缓冲区 |
| `<leader>bl` | 下一个缓冲区 |
| `<leader>bp` | 选择关闭标签 |
| `<leader>bc` | 关闭其他标签 |
| `<leader>bd` | 删除当前缓冲区 |

**特性**:
- 显示 LSP 诊断图标
- 排序和分组

---

### 18. tokyonight.nvim - 颜色主题

**功能**: 美丽的 Neovim 颜色主题，支持多种风格。

**配置**: `style = "moon"` (可选项: night, storm, day, light)

---

### 19. dashboard-nvim - 启动画面

**功能**: 现代化启动画面，显示快捷方式、项目和最近文件。

**快捷键** (启动画面):
| 快捷键 | 功能 |
|--------|------|
| `n` | 新建文件 |
| `r` | 最近文件 |
| `f` | 查找文件 |
| `u` | 更新插件 |
| `s` | 打开设置 |
| `q` | 退出 |

---

### 20. which-key.nvim - 快捷键提示

**功能**: 当你输入 `<leader>` 时，自动显示可用的快捷键列表。

**特性**:
- 自动发现带 `desc` 的快捷键
- 现代 UI 风格
- 标记和寄存器显示

---

### 21. hop.nvim - 快速跳转

**功能**: 快速跳转到光标位置，只需输入目标词的前两个字母。

**快捷键**:
| 快捷键 | 功能 |
|--------|------|
| `ff` | 跳转到单词 (Hop Word) |

---

### 22. toggleterm.nvim - 嵌入式终端

**功能**: 在 Neovim 中嵌入终端窗口。

**快捷键**:
| 快捷键 | 功能 |
|--------|------|
| `<C-t>` | 打开/关闭终端 |

**配置**:
- 默认垂直分屏
- 退出终端后自动关闭
- 支持响应式布局（小屏幕自动切换为水平）

---

### 23. lsp-features - LSP 增强功能

**功能**: 为 LSP 添加高级功能增强。

**特性**:
| 功能 | 描述 |
|------|------|
| Document Highlight | 高亮光标下的相同符号 |
| Inlay Hint | 行内类型提示 |
| CodeLens | 代码引用计数 |
| Inline Completion | 行内补全 |
| Linked Editing | 链接编辑（如 HTML 标签同时编辑）|

**Inline Completion 快捷键**:
| 快捷键 | 功能 |
|--------|------|
| `<M-CR>` | 获取当前行内补全 |
| `<M->` | 下一个补全 |
| `<M-[>` | 上一个补全 |

---

## 快捷键速查表

### 通用快捷键
| 快捷键 | 功能 |
|--------|------|
| `Space` | Leader 键前缀 |
| `jj` | 退出插入模式 |
| `<C-s>` | 保存文件 |
| `<C-z>` | 撤销 |
| `H/L` | 跳转到行首/行尾 |
| `tt` / `bb` | 上/下翻页 |
| `<Esc>` (终端) | 退出终端模式 |

### 文件操作
| 快捷键 | 功能 |
|--------|------|
| `<leader>e` | 打开 Yazi 文件管理器 |
| `<leader>ff` | 查找文件 (Telescope) |
| `<leader>fg` | 全局搜索 (Telescope) |
| `<leader>bh` | 上一个缓冲区 |
| `<leader>bl` | 下一个缓冲区 |
| `<leader>bp` | 选择关闭标签 |
| `<leader>bc` | 关闭其他标签 |
| `<leader>bd` | 删除当前缓冲区 |

### 代码导航
| 快捷键 | 功能 |
|--------|------|
| `gd` | 跳转到定义 (Lspsaga) |
| `<F2>` | 重命名符号 |
| `<leader>n` | 下一个诊断信息 |
| `<leader>p` | 上一个诊断信息 |
| `<leader>t` | 切换代码大纲 (Aerial) |
| `ff` | 快速单词跳转 (Hop) |

### 代码编辑
| 快捷键 | 功能 |
|--------|------|
| `<leader>ft` | 格式化代码 (Conform) |
| `<C-n>` | 多光标：选中下一个匹配 |
| `<C-M-Up>` | 多光标：在上方添加光标 |
| `<C-M-Down>` | 多光标：在下方添加光标 |

### AI 助手
| 快捷键 | 功能 |
|--------|------|
| `<leader>cc` | 打开 CodeCompanion 聊天 |
| `<leader><tab>` | 打开仪表盘 |
| `v` + `ga` | 将选中文本添加到聊天 |

### 通知
| 快捷键 | 功能 |
|--------|------|
| `<leader>dn` | 关闭通知 (Noice) |

---

## 依赖项

| 依赖 | 用途 | 安装 (Arch Linux) |
|------|------|-------------------|
| Neovim 0.11+ | 编辑器 | `pacman -S neovim` |
| Git | 插件管理 | `pacman -S git` |
| Node.js | LSP/MCP 服务器 | `pacman -S nodejs` |
| gcc | Treesitter 编译 | `pacman -S gcc` |
| ripgrep | Telescope 搜索 | `pacman -S ripgrep` |
| fd | Telescope 文件搜索 | `pacman -S fd` |

---

## 环境变量

在 `~/.zshenv` 或 `~/.bashrc` 中设置:

```bash
export ANTHROPIC_API_KEY="your-key"
export ANTHROPIC_MODEL="claude-3-5-sonnet-20241022"
export TAVILY_API_KEY="your-key"
```

---

## 文件结构

```
~/.config/nvim/
├── init.lua                    # 入口文件 - 加载核心模块
├── lua/
│   ├── core/
│   │   ├── basic.lua          # 编辑器选项 (行号、缩进等)
│   │   ├── keymap.lua         # 所有快捷键绑定
│   │   └── lazy.lua           # lazy.nvim 引导和插件导入
│   └── plugins/              # 各插件配置文件 (lazy.nvim spec)
├── snippets/                  # LuaSnip 代码片段 (JSON)
└── plugin/                    # 生成的插件目录
```
