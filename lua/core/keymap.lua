--- @diagnostic disable: undefined-global

-- 自动重载 keymap (开发时使用)
local keymap_reload_group = vim.api.nvim_create_augroup("UserKeymapReload", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	group = keymap_reload_group,
	pattern = "**/keymap.lua",
	callback = function()
		vim.cmd("source ~/.config/nvim/lua/core/keymap.lua")
		vim.notify("keymap.lua 已重新加载", vim.log.levels.INFO)
	end,
})

-- Leader 键设置
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- 为 Leader 键添加描述 (主要用于 Telescope 等插件的显示)
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true, desc = "Leader 键 (Prefix Key) --系统" })

-- <Ctrl-z> 绑定为撤销 (Vim 原生支持挂起，此处自定义为 undo)
vim.keymap.set({ "n", "i" }, "<C-z>", "<Cmd>undo<CR>", { silent = true, desc = "撤销 (Undo) --自定义" })

-- F1: 显示快捷键帮助 (依赖 Telescope 插件)
vim.keymap.set({ "n", "i" }, "<F1>", function()
	require("telescope.builtin").keymaps()
end, { noremap = true, silent = true, desc = "显示快捷键列表 (Show Keymaps) --系统" })

-- Insert 模式下：jj = Esc (快速退出插入模式)，但在 yazi 缓冲区中禁用
vim.keymap.set("i", "jj", function()
	if vim.bo.filetype ~= "yazi" then
		return "<Esc>"
	end
	return "jj"
end, { expr = true, noremap = true, silent = true, desc = "退出插入模式 (Exit Insert Mode) --自定义" })

-- Insert 模式下：<C-s> 保存文件 (退出插入 → 保存 → 回到插入)
vim.keymap.set("i", "<C-s>", "<Cmd>write<CR>", {
	noremap = true,
	silent = true,
	desc = "保存文件 (Save File) --自定义",
})

-- Normal 模式下：<C-s> 保存文件
vim.keymap.set("n", "<C-s>", "<Cmd>write<CR>", {
	noremap = true,
	silent = true,
	desc = "保存文件 (Save File) --自定义",
})

-- 自定义翻页：tt = PageUp, bb = PageDown
vim.keymap.set("n", "tt", "<C-b>", { noremap = true, silent = true, desc = "向上翻页 (Page Up) --自定义" })
vim.keymap.set("n", "bb", "<C-f>", { noremap = true, silent = true, desc = "向下翻页 (Page Down) --自定义" })

-- H/L 自定义：跳转到行首/行尾
vim.keymap.set({ "n", "v" }, "H", "0", { desc = "跳转到行首 (Start of Line) --自定义" })
vim.keymap.set({ "n", "v" }, "L", "$", { desc = "跳转到行尾 (End of Line) --自定义" })

-- Telescope 插件快捷键
vim.keymap.set("n", "<leader>ff", function()
	require("telescope.builtin").find_files()
end, { desc = "查找文件 (Find Files) --插件(Telescope)" })
vim.keymap.set("n", "<leader>fg", function()
	require("telescope.builtin").live_grep()
end, { desc = "全局搜索 (Live Grep) --插件(Telescope)" })

-- Hop 插件快捷键
vim.keymap.set("n", "<leader>hw", "<Cmd>HopWord<CR>", {
	silent = true,
	desc = "单词跳转 (Hop Word) --插件(Hop)",
})

-- Lspsaga 插件快捷键
vim.keymap.set("n", "K", "<Cmd>Lspsaga hover_doc<CR>", {
	desc = "悬浮文档 (Hover Documentation) --插件(Lspsaga)",
})
vim.keymap.set("n", "<leader>ld", "<Cmd>Lspsaga show_line_diagnostics<CR>", {
	desc = "显示当前行诊断 (Line Diagnostics) --插件(Lspsaga)",
})
vim.keymap.set("n", "<F2>", function()
	vim.lsp.buf.rename()
end, { desc = "全局重命名变量 (Rename) --LSP" })
vim.keymap.set(
	"n",
	"<leader>n",
	"<Cmd>Lspsaga diagnostic_jump_next<CR>",
	{ desc = "跳转到下一个诊断 (Next Diagnostic) --插件(Lspsaga)" }
)

vim.keymap.set(
	"n",
	"<leader>p",
	"<Cmd>Lspsaga diagnostic_jump_prev<CR>",
	{ desc = "跳转到上一个诊断 (Prev Diagnostic) --插件(Lspsaga)" }
)

-- Conform 插件快捷键
vim.keymap.set("n", "<leader>ft", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "格式化代码 (Format Code) --插件(Conform)" })

-- Bufferline 插件快捷键
vim.keymap.set("n", "<leader>bh", "<Cmd>BufferLineCyclePrev<CR>", {
	desc = "上一个缓冲区 (Previous Buffer) --插件(Bufferline)",
})
vim.keymap.set("n", "<leader>bl", "<Cmd>BufferLineCycleNext<CR>", {
	desc = "下一个缓冲区 (Next Buffer) --插件(Bufferline)",
})
vim.keymap.set("n", "<leader>bp", "<Cmd>BufferLinePickClose<CR>", {
	desc = "选择关闭缓冲区 (Pick Close Buffer) --插件(Bufferline)",
})
vim.keymap.set("n", "<leader>bc", "<Cmd>BufferLineCloseOthers<CR>", {
	desc = "关闭其他缓冲区 (Close Other Buffers) --插件(Bufferline)",
})
vim.keymap.set("n", "<leader>bd", function()
	local bufnr = vim.api.nvim_get_current_buf()
	if vim.bo[bufnr].modified then
		return vim.notify("缓冲区存在未保存的修改", vim.log.levels.WARN)
	end

	local ok, err = pcall(vim.api.nvim_buf_delete, bufnr, { force = false })
	if not ok then
		vim.notify(tostring(err), vim.log.levels.ERROR)
	end
end, {
	desc = "关闭当前缓冲区 (Delete Buffer) --插件(Bufferline)",
})

-- Yazi 插件快捷键
vim.keymap.set("n", "<leader>e", "<cmd>Yazi<CR>", {
	desc = "打开文件管理器 (Open yazi) --插件(Yazi)",
})

-- Aerial 插件快捷键
vim.keymap.set("n", "<leader>t", function()
	local ok, aerial = pcall(require, "aerial")
	if ok then
		aerial.toggle({ focus = true })
	else
		vim.notify("aerial.nvim 插件未加载", vim.log.levels.WARN)
	end
end, {
	desc = "打开/关闭大纲 (Toggle Outline) --插件(Aerial)",
})

-- Dashboard 与 CodeCompanion 插件快捷键
vim.keymap.set({ "n", "v" }, "<leader><tab>", "<cmd>Dashboard<CR>", {
	desc = "打开仪表盘 (Open Dashboard) --插件(Dashboard)",
})
vim.keymap.set({ "n", "v" }, "<leader>c", "<cmd>CodeCompanionChat Toggle<CR>", {
	desc = "CodeCompanion 聊天窗口 (Toggle Chat) --插件(CodeCompanion)",
})
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<CR>", {
	desc = "CodeCompanion 添加选中文本 (Add Selection) --插件(CodeCompanion)",
})

-- ToggleTerm 插件快捷键
vim.keymap.set({ "n", "i", "t" }, "<C-t>", "<Cmd>ToggleTerm<CR>", {
	desc = "打开/关闭终端 (Toggle Terminal) --插件(ToggleTerm)",
})

-- Neovim LSP inline completion
vim.keymap.set("i", "<M-CR>", function()
	vim.lsp.inline_completion.get()
end, { desc = "接受内联补全 (Accept Inline Completion) --LSP" })
vim.keymap.set("i", "<M-]>", function()
	vim.lsp.inline_completion.select({ count = 1 })
end, { desc = "下一个内联补全 (Next Inline Completion) --LSP" })
vim.keymap.set("i", "<M-[>", function()
	vim.lsp.inline_completion.select({ count = -1 })
end, { desc = "上一个内联补全 (Previous Inline Completion) --LSP" })

-- Terminal 模式下：Esc 切换到 Normal 模式 (退出终端插入模式)
vim.keymap.set(
	"t",
	"<Esc>",
	[[<C-\><C-n>]],
	{ noremap = true, silent = true, desc = "终端模式 -> 普通模式 (Terminal -> Normal) --系统" }
)

-- Noice.nvim：dismiss 通知
vim.keymap.set("n", "<leader>dn", function()
	require("noice").cmd("dismiss")
end, { silent = true, desc = "关闭通知 (Dismiss Notification) --插件(Noice)" })

-- LSP 跳转到定义 (使用 LSPSaga)
vim.keymap.set(
	"n",
	"gd",
	"<Cmd>Lspsaga goto_definition<CR>",
	{ silent = true, desc = "跳转到定义 (Go to Definition) --插件(Lspsaga)" }
)

-- WhichKey 配置：modern preset 会自动发现带 desc 的 leader 快捷键
-- 无需手动 register，which-key 会根据 keymap 的 desc 自动分组显示
