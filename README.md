# 🚀 现代 Neovim 配置 (Neovim 0.11+)

本仓库提供了一个**高性能、现代化的 Neovim 配置**，使用 Lua 编写。它集成了一系列精心挑选的插件，为您提供：
- 通过 `vim.loader` 字节码缓存实现的**快速启动**
- 支持多种语言（Python、C++、Lua 等）的**完整 LSP 支持**，通过 `mason.nvim` 自动安装
- 由 `nvim-cmp` 驱动的**智能补全**
- 通过 `nvim-treesitter` 实现的语法高亮、缩进和文本对象
- 通过 `telescope.nvim`、`nvim-tree` 和 `bufferline.nvim` 实现的模糊查找、文件资源管理和缓冲区标签
- 通过 **Avante.nvim** 和 **MCP Hub** 实现的**AI 辅助编程**
- 内置 **Gemini CLI**，在编辑器中直接与 Google AI 对话

---

## 📂 目录结构
```
~/.config/nvim/
├─ init.lua                # 入口点 - 加载核心配置和插件
├─ lua/
│  ├─ core/               # 基础选项、快捷键和懒加载配置
│  │   ├─ basic.lua        # 通用 Neovim 选项
│  │   ├─ keymap.lua       # 全局快捷键映射
│  │   ├─ lazy.lua         # lazy.nvim 引导配置
│  │   └─ neovide_config.lua # Neovide 图形界面配置
│  └─ plugins/            # 单个插件配置
│      ├─ avante.lua        # AI 助手集成
│      ├─ bufferline.lua    # 缓冲区标签 UI
│      ├─ cmp.lua           # 补全引擎
│      ├─ diagnostics.lua   # 诊断配置
│      ├─ gemini-cli.lua    # Gemini CLI 集成
│      ├─ grug-far.lua      # 全局搜索替换
│      ├─ hop.lua           # 快速导航
│      ├─ indent-blankline.lua # 缩进指南
│      ├─ lspsaga.lua       # 增强的 LSP UI
│      ├─ lualine.lua       # 状态栏
│      ├─ mason.lua         # 外部工具安装器
│      ├─ mcphub.lua        # MCP Hub 服务器管理
│      ├─ multicursor.lua   # 多光标编辑
│      ├─ noice.lua         # 现代化通知系统
│      ├─ none-ls.lua       # 诊断和格式化
│      ├─ nvim-autopairs.lua # 自动括号配对
│      ├─ nvim-surround.lua # 环绕文本对象
│      ├─ nvim-tree.lua     # 文件资源管理器
│      ├─ nvim-treesitter.lua # 语法高亮和查询
│      ├─ render-markdown.lua # Markdown 渲染
│      ├─ telescope.lua     # 模糊查找器
│      ├─ toggleterm.lua    # 终端管理
│      └─ tokyonight.lua    # Tokyo Night 主题
└─ AGENTS.md               # 未来维护者的交接文档
```

---

## ⚡ 核心功能
- **即时启动** - `vim.loader.enable()` 缓存编译后的 Lua 字节码
- **LSP 自动设置** - `mason.nvim` 确保语言服务器安装；根据文件类型懒启动服务器
- **智能补全** - `nvim-cmp` 提供 LSP、缓冲区、路径和代码片段等多种源
- **Treesitter** - 语法高亮、增量选择和文本对象
- **AI 辅助** - `avante.nvim` 集成多种 AI 模型和 `mcphub.nvim` 提供 MCP 服务器支持
- **Gemini CLI** - 内置 Gemini CLI，直接在编辑器中与 Google AI 对话
- **一致的 UI** - `tokyonight.nvim` 主题、`lualine` 状态栏、`bufferline` 标签页
- **现代化界面** - `noice.nvim` 提供美观的命令行和通知界面

---

## 📦 插件概览

### 核心插件（自动安装）
| 插件 | 用途 | 依赖 |
|------|------|------|
| `lazy.nvim` | 插件管理器 & 懒加载框架 | Git |
| `nvim-tree` | 文件资源管理器 | `nvim-web-devicons` |
| `telescope.nvim` | 模糊查找器和实时搜索 | `plenary.nvim`, `telescope-ui-select.nvim`, `fd`, `ripgrep` |
| `nvim-cmp` | 补全框架 | `cmp-nvim-lsp`, `cmp-buffer`, `cmp-path`, `cmp_luasnip`, `lspkind` |
| `LuaSnip` | 代码片段引擎 | - |
| `nvim-lspconfig` + `mason.nvim` | LSP 服务器管理 | `mason-lspconfig.nvim`, `mason-tool-installer.nvim`, Node.js |
| `nvim-treesitter` | 语法高亮和查询 | GCC (编译) |
| `bufferline.nvim` | 缓冲区/标签栏 | `nvim-web-devicons` |
| `lualine.nvim` | 状态栏 | - |
| `lspsaga.nvim` | 增强的 LSP UI | - |
| `none-ls.nvim` | 诊断、代码操作和格式化 | `plenary.nvim`, 外部工具 |
| `hop.nvim` | 按字符/单词快速导航 | - |
| `grug-far.nvim` | 项目范围的搜索和替换 | `ripgrep`, `gcc` |
| `avante.nvim` | AI 代码助手 | `avante_lib`, Node.js, npm |
| `mcphub.nvim` | MCP 服务器管理 | Node.js |
| `claudecode.nvim` | Claude Code 集成 | `snacks.nvim` |
| `snacks.nvim` | 工具库 | - |
| `nvim-surround` | 轻松环绕文本 | - |
| `indent-blankline.nvim` | 缩进指南 | - |
| `nvim-autopairs` | 自动括号配对 | - |
| `vim-visual-multi` | 多光标编辑 | - |
| `toggleterm.nvim` | 终端管理 | - |
| `noice.nvim` | 现代化通知和命令行界面 | `nui.nvim`, `nvim-notify` |
| `nvim-notify` | 美观的通知系统 | - |
| `tokyonight.nvim` | Tokyo Night 主题 | - |
| `render-markdown.nvim` | Markdown 渲染 | `nvim-web-devicons` |
| `dashboard-nvim` | 启动画面 | - |

### 完整插件列表（来自 lazy-lock.json）
```
lazy.nvim, avante.nvim, bufferline.nvim, claudecode.nvim,
cmp-buffer, cmp-cmdline, cmp-nvim-lsp, cmp-path, cmp-under-comparator,
cmp_luasnip, dashboard-nvim, grug-far.nvim, hop.nvim,
indent-blankline.nvim, lspkind.nvim, lspsaga.nvim, lualine.nvim,
mason-lspconfig.nvim, mason-tool-installer.nvim, mason.nvim,
mcphub.nvim, noice.nvim, none-ls.nvim, nui.nvim,
nvim-autopairs, nvim-cmp, nvim-lspconfig, nvim-notify,
nvim-surround, nvim-tree.lua, nvim-treesitter, nvim-web-devicons,
plenary.nvim, render-markdown.nvim, snacks.nvim,
telescope-ui-select.nvim, telescope.nvim, toggleterm.nvim,
tokyonight.nvim, vim-visual-multi, LuaSnip
```

---

## ⌨️ 快捷键（精选）
| 按键 | 模式 | 描述 |
|------|------|------|
| `<Space>` | Normal | Leader 前缀 |
| `<C-s>` | Normal/Insert | 保存文件 |
| `jj` | Insert | 退出插入模式 |
| `<C-t>` | Normal | 切换底部终端 |
| `<Leader>ff` | Normal | 查找文件（Telescope） |
| `<Leader>fg` | Normal | 实时搜索（Telescope） |
| `<Leader>fr` | Normal | 全局替换（Grug-far） |
| `<Leader>u` | Normal | 切换文件树 |
| `<Leader>aa` | Normal | 显示 AI 助手侧边栏 (Avante) |
| `<Leader>gt` | Normal | **新增:** 切换 Gemini CLI |
| `<Leader>ga` | Normal | **新增:** 启动 Gemini 对话 |
| `gd` | Normal | 跳转到定义（LSP） |
| `gr` | Normal | 列出引用 |
| `K` | Normal | 悬停文档 |
| `<Space>rn` | Normal | 重命名符号 |
| `<Space>ca` | Normal | 代码操作 |
| `<Space>f` | Normal | 格式化缓冲区 |
| `<F1>` | Normal | 打开可搜索的快捷键面板 |

---

## 🛠️ 安装指南

### 1. 系统依赖

#### 必需依赖
| 依赖 | 说明 | 安装 (Arch Linux) | 安装 (Ubuntu/Debian) | 安装 (macOS) |
|------|------|-------------------|----------------------|--------------|
| **Neovim ≥ 0.11** | 文本编辑器 | `pacman -S neovim` | `apt install neovim` 或 [AppImage](https://github.com/neovim/neovim/releases) | `brew install neovim` |
| **Git** | 克隆插件仓库 | `pacman -S git` | `apt install git` | `brew install git` |
| **Node.js ≥ 18** | LSP 服务器、Avante 等 | `pacman -S nodejs` | `apt install nodejs npm` | `brew install node` |
| **npm** | Node.js 包管理器 | (内置) | (内置) | (内置) |
| **gcc** | 编译 Treesitter 模块 | `pacman -S gcc` | `apt install build-essential` | (Xcode Command Line Tools) |

#### 推荐依赖（增强体验）
| 依赖 | 说明 | 安装 (Arch Linux) | 安装 (Ubuntu/Debian) | 安装 (macOS) |
|------|------|-------------------|----------------------|--------------|
| **ripgrep** | Telescope 实时搜索 | `pacman -S ripgrep` | `apt install ripgrep` | `brew install ripgrep` |
| **fd** | Telescope 文件搜索 | `pacman -S fd` | `apt install fd-find` | `brew install fd` |
| **bat** | 文件预览增强 | `pacman -S bat` | `apt install bat` | `brew install bat` |
| **curl** | 网络请求 | `pacman -S curl` | `apt install curl` | (内置) |
| **wget** | 网络下载 | `pacman -S wget` | `apt install wget` | (内置) |
| **Python** | Python LSP 和格式化 | `pacman -S python` | `apt install python3 python3-pip` | (内置) |
| **racket** | Racket LSP | `pacman -S racket` | `apt install racket` | `brew install racket` |
| **xclip** | 系统剪贴板支持 | `pacman -S xclip` | `apt install xclip` | (可选) |

#### 可选依赖（特定功能）
| 依赖 | 用途 | 安装命令 |
|------|------|----------|
| **Docker** | Avante RAG 功能 | `pacman -S docker` / `apt install docker.io` |
| **uv** | Python 包管理（更快） | `pip install uv` 或 `curl -LsSf https://astral.sh/uv/install.sh` |

### 2. 环境变量（AI 功能）
在 `~/.zshrc` 或 `~/.bashrc` 中设置：
```bash
# API Keys（根据需要选择）
export OPEN_SOURCE_API_KEY="your-key"
export SILICONFLOW_API_KEY="your-key"
export TAVILY_API_KEY="your-key"

# 或者 Ollama
export OLLAMA_HOST="http://localhost:11434"
```

### 3. 克隆配置
```bash
git clone git@github.com:HowardChouX/easynvim.git ~/.config/nvim
# 或
git clone https://github.com/HowardChouX/easynvim.git ~/.config/nvim
```

### 4. 首次启动
首次启动 Neovim 时，`lazy.nvim` 将自动安装所有插件：
```bash
nvim
```

### 5. 同步插件（如需强制重新安装）
```vim
:Lazy sync
```

### 6. 安装语言服务器和工具
运行 Mason 安装所需的 LSP 服务器：
```vim
:Mason
```

**预配置的自动安装：**

**LSP 服务器（自动安装）：**
- `lua_ls` - Lua 语言服务器
- `pyright` - Python 语言服务器
- `clangd` - C/C++ 语言服务器
- `racketlangserver` - Racket 语言服务器

**格式化工具（自动安装）：**
- `stylua` - Lua 代码格式化
- `black` - Python 代码格式化
- `clang-format` - C/C++ 代码格式化

### 7. 安装 Treesitter 语法
```vim
:TSInstall all
```

### 8. 验证安装
```vim
:Lazy          -- 查看插件状态
:Mason         -- 查看已安装的 LSP
:LspInfo       -- 查看 LSP 状态
:checkhealth   -- 检查 Neovim 健康状态
```

2. **克隆配置**
   ```bash
   git clone git@github.com:HowardChouX/easynvim.git ~/.config/nvim
   ```

3. **启动 Neovim** - 首次启动时 `lazy.nvim` 将自动安装所有插件

4. **同步插件**（如果需要强制重新安装）
   ```vim
   :Lazy sync
   ```

5. **安装语言服务器**
   ```vim
   :Mason
   ```
   然后安装您需要的服务器（例如 `pyright`、`ruff`、`clangd`）

6. **验证 AI 服务** - 如果使用RAG确保 Docker 正在运行，但默认关闭了效果不好用,并在 `~/.zshrc` 中设置所需的 API 密钥：
   ```bash
   export OPEN_SOURCE_API_KEY="..."
   export SILICONFLOW_API_KEY="..."
   export TAVILY_API_KEY="..."
   ```
   Avante AI 助手将在加载时自动集成 MCP Hub 服务

---

## 🐞 故障排除

### 常见问题
1. **插件安装失败**
   - 检查网络连接
   - 检查 `git` 是否在 `PATH` 中
   - 运行 `:Lazy clean` 然后 `:Lazy sync`

2. **LSP 未附加**
   - 运行 `:Mason` 确保服务器已安装
   - 检查 `:LspInfo` 获取活动客户端
   - 确认 Node.js 已正确安装

3. **Treesitter 语法高亮不工作**
   - 运行 `:TSUpdate` 更新语法模块
   - 运行 `:TSInstall all` 重新安装语法
   - 确认 gcc 已正确安装

4. **Telescope 搜索无结果**
   - 安装 `fd`: `pacman -S fd` (Arch) / `apt install fd-find` (Ubuntu)
   - 安装 `ripgrep`: `pacman -S ripgrep` (Arch) / `apt install ripgrep` (Ubuntu)
   - 运行 `:checkhealth telescope` 检查配置

5. **快捷键不工作**
   - 验证 `lua/core/keymap.lua` 是否在 `init.lua` 中加载
   - 使用 `:Telescope keymaps` 查看所有快捷键

6. **AI 助手问题（Avante）**
   - 确保 Docker 正在运行（如果使用 RAG）
   - 检查 MCP Hub 连接状态
   - 验证 API 密钥配置

7. **主题缺失**
   - 安装缺失的主题插件
   - 或在 `lua/plugins/tokyonight.lua` 中更改名称

8. **剪贴板不工作**
   - 安装 `xclip` 或 `xsel`: `pacman -S xclip`
   - Neovim 编译时需启用 `+clipboard`

### 诊断命令
```vim
:checkhealth           -- 全面检查
:checkhealth provider  -- 检查外部工具
:Lazy profile          -- 插件性能分析
:LspInfo               -- LSP 状态
:NullLsInfo            -- 格式化工具状态
```

---

## 📄 功能特性

### 编辑体验
- **智能补全**：集成 LSP、缓冲区、路径和代码片段的多源补全
- **语法高亮**：基于 Treesitter 的现代化语法高亮
- **快速导航**：Hop 插件的字符级快速跳转
- **多光标编辑**：Visual-Multi 插件的多光标支持
- **环绕操作**：轻松添加、修改和删除文本环绕符号
- **自动配对**：自动完成括号、引号等符号配对

### 开发工具
- **语言服务器**：支持 Python、C++、Lua、Racket等
- **代码格式化**：通过 none-ls 和 LSP 提供自动格式化
- **诊断信息**：normal模式下显示错误和警告
- **现代化界面**：Noice.nvim 提供美观的通知和命令行界面

### AI 辅助
- **Avante.nvim**：基于 MCP Hub 的 AI 编程助手
- **Gemini CLI**：直接在 Neovim 中访问 Google Gemini
- **多模型支持**：支持 Cherryin (GLM-4.6、DeepSeek、Qwen)、OpenAI、Ollama 等多种模型
- **MCP 集成**：自动集成文件系统、Git、时间、SQLite 等 MCP 服务器
- **智能权限**：安全的自动授权机制，保护项目安全
- **代码生成**：智能代码建议和生成

### 界面美化
- **主题系统**：Tokyo Night 主题，支持多种风格
- **状态栏**：Lualine 提供丰富的状态信息
- **文件树**：Nvim-tree 提供直观的文件导航
- **缓冲区管理**：Bufferline 提供标签页式缓冲区管理
- **缩进指南**：清晰的缩进线可视化
- **Neovide 支持**：针对 GUI 版本的优化配置

---

## ⚙️ 配置说明

### 核心配置
配置分为四个主要部分：
- `basic.lua`：基础 Neovim 选项设置
- `keymap.lua`：全局快捷键映射（包含智能描述系统）
- `lazy.lua`：插件管理器设置
- `neovide_config.lua`：Neovide 图形界面专用配置

### 插件配置
每个插件在 `lua/plugins/` 目录下有独立的配置文件，支持：
- 懒加载优化（VeryLazy、事件触发等）
- 自定义选项和依赖管理
- 快捷键集成和配置

### 自定义命令
- `:Mason` 系列命令：LSP 服务器管理
- `:Telescope` 系列命令：文件查找和搜索
- `:Lspsaga` 系列命令：增强 LSP 操作
- `:Avante` 系列命令：AI 助手操作
- `:Gemini` 系列命令: Gemini CLI 操作
- `:NullLsInfo`：格式化工具状态

---

## 🔧 命令行参考

### Mason 命令
```vim
:Mason              # 打开 Mason UI
:MasonInstall       # 安装特定包
:MasonUpdate        # 更新所有包
:MasonUninstall     # 卸载包
:MasonLog           # 查看日志
```

### Telescope 命令
```vim
:Telescope find_files    # 查找文件
:Telescope live_grep     # 实时搜索
:Telescope keymaps       # 快捷键搜索
:Telescope buffers       # 缓冲区搜索
```

---

## 📁 配置文件 API

### 基础配置接口
```lua
-- 在 basic.lua 中设置的基础选项
vim.opt.number = true          -- 显示行号
vim.opt.relativenumber = true  -- 相对行号
vim.opt.expandtab = true       -- Tab 转空格
vim.g.mapleader = " "          -- Leader 键
```

### LSP 配置接口
```lua
-- 在 mason.lua 中定义的服务器配置
vim.lsp.config("lua_ls", {
    filetypes = { "lua" },
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
})
```

### 插件配置接口
每个插件通过 `lazy.nvim` 的配置系统进行管理，支持事件触发、按键触发等多种加载策略。

---

## 🔄 与外部工具集成

### MCP Hub 集成
- **自动服务器管理**：智能启动和停止 MCP 服务器
- **安全权限控制**：危险操作需要手动确认
- **文件系统集成**：安全的文件读写操作
- **Git 状态显示**：内置 Git 状态信息

### Shell 集成
- **内置终端支持**：ToggleTerm 提供便捷的终端访问
- **快捷键快速打开**：Ctrl+T 快速打开底部终端

---

## 🔍 故障排除 FAQ

### Q: 插件加载失败怎么办？
A: 检查网络连接和 `git` 是否在 `PATH` 中。运行 `:Lazy clean` 然后 `:Lazy sync`

### Q: LSP 服务器不工作？
A: 运行 `:Mason` 确保服务器已安装，并检查 `:LspInfo`

### Q: AI 助手无法启动？
A: 确保 MCP Hub 连接正常，检查 API 密钥配置

### Q: 快捷键冲突？
A: 使用 `:Telescope keymaps` 查看所有快捷键及其来源

---

## 📚 维护者手册

### 添加新插件
1. 在 `lua/plugins/` 目录下创建新的配置文件
2. 使用 `lazy.nvim` 的配置语法
3. 测试插件的懒加载行为

### 自定义主题
- 修改 `lua/plugins/tokyonight.lua`
- 支持多种 Tokyo Night 风格
- 可替换为其他主题插件

### 性能优化
- 使用 `vim.loader` 缓存
- 合理配置懒加载策略
- 定期清理不必要的插件

### 调试技巧
- 使用 `:Lazy profile` 分析插件性能
- `:LspInfo` 检查 LSP 状态
- `:NullLsInfo` 检查格式化工具状态

---