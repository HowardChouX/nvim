-- 告诉Lua语言服务器vim是全局变量
--- @diagnostic disable: undefined-global

--显示行号
vim.opt.number = true

--显示相对行号
vim.opt.relativenumber = false

--光标所在行高亮
vim.opt.cursorline = true

--单行字符数阈值高亮设置为80
--vim.opt.colorcolumn = "80"

--tap转换为空格
vim.opt.expandtab = true

--tap转换为空格数量的默认值
vim.opt.tabstop = 4

--将换行缩进设置为零避免与tanstop冲突
vim.opt.shiftwidth = 4

--自动加载外部修改
vim.opt.autoread = true

--分屏默认设置为下方和右方
vim.opt.splitbelow = true
vim.opt.splitright = true

--/查找大小写敏感
vim.opt.ignorecase = true
vim.opt.smartcase = true

--查找不显示高亮
vim.opt.hlsearch = false

--关闭 Neovim 底部的模式提示信息
vim.opt.showmode = false

-- Leader 键设置 (在 keymap.lua 中)

--绑定默认寄存器和系统剪贴板
vim.opt.clipboard = "unnamedplus"

-- 组合键检测超时时间 (单位: 毫秒)
-- 默认值是 1000ms。降低此值可以减少按键延迟，避免误触组合键 (如 bb vs b b)
-- 建议值：200-300ms
vim.opt.timeoutlen = 350

--暗色背景
vim.o.background = "dark"

-- 确保有 24位色支持
vim.opt.termguicolors = true

-- 禁用 perl provider (避免警告)
vim.g.loaded_perl_provider = 0

-- 禁用鼠标支持 (所有模式)
vim.opt.mouse = ""
