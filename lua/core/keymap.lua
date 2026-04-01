--- @diagnostic disable: undefined-global

-- 自动重载 keymap (开发时使用)
vim.api.nvim_create_autocmd("BufWritePost", {
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
vim.keymap.set(
	{ "n", "i" },
	"<F1>",
	"<cmd>Telescope keymaps<CR>",
	{ noremap = true, silent = true, desc = "显示快捷键列表 (Show Keymaps) --系统" }
)

-- Insert 模式下：jj = Esc (快速退出插入模式)，但在 yazi 缓冲区中禁用
vim.keymap.set("i", "jj", function()
	if vim.bo.filetype ~= "yazi" then
		vim.cmd("stopinsert")
	end
end, { noremap = true, silent = true, desc = "退出插入模式 (Exit Insert Mode) --自定义" })

-- Insert 模式下：<C-s> 保存文件 (退出插入 → 保存 → 回到插入)
vim.keymap.set(
	"i",
	"<C-s>",
	"<Esc>:w<CR>a",
	{ noremap = true, silent = true, desc = "保存文件 (Save File) --自定义" }
)

-- Normal 模式下：<C-s> 保存文件
vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true, desc = "保存文件 (Save File) --自定义" })

-- 自定义翻页：tt = PageUp, bb = PageDown
vim.keymap.set("n", "tt", "<C-b>", { noremap = true, silent = true, desc = "向上翻页 (Page Up) --自定义" })
vim.keymap.set("n", "bb", "<C-f>", { noremap = true, silent = true, desc = "向下翻页 (Page Down) --自定义" })

-- H/L 自定义：跳转到行首/行尾
vim.keymap.set({ "n", "v" }, "H", "0", { desc = "跳转到行首 (Start of Line) --自定义" })
vim.keymap.set({ "n", "v" }, "L", "$", { desc = "跳转到行尾 (End of Line) --自定义" })

-- Telescope 插件快捷键
vim.keymap.set(
	"n",
	"<leader>ff",
	"<cmd>Telescope find_files<CR>",
	{ desc = "查找文件 (Find Files) --插件(Telescope)" }
)
vim.keymap.set("n", "<leader>fg", function()
	-- 检查 ripgrep 是否可用
	local has_rg = false
	if vim.fn.executable("rg") == 1 or vim.fn.executable("ripgrep") == 1 then
		has_rg = true
	end

	if has_rg then
		-- ripgrep 可用，使用 live_grep 进行全局搜索
		vim.cmd("Telescope live_grep")
	else
		-- ripgrep 不可用，使用普通的 find_files 替代并发出警告
		vim.notify(
			"ripgrep 未安装，使用文件查找替代。推荐安装 ripgrep 以获得更好的搜索体验。",
			vim.log.levels.WARN
		)
		vim.cmd("Telescope find_files")
	end
end, { desc = "全局搜索 (Live Grep) --插件(Telescope)" })

-- Dashboard 插件快捷键
vim.keymap.set("n", "<leader>d", ":Dashboard<CR>", { desc = "打开仪表盘 (Open Dashboard) --插件(Dashboard)" })

-- Bufferline 插件快捷键
vim.keymap.set(
	"n",
	"<leader>bh",
	":BufferLineCyclePrev<CR>",
	{ silent = true, desc = "切换上一个标签 (Prev Buffer) --插件(Bufferline)" }
)
vim.keymap.set(
	"n",
	"<leader>bl",
	":BufferLineCycleNext<CR>",
	{ silent = true, desc = "切换下一个标签 (Next Buffer) --插件(Bufferline)" }
)
vim.keymap.set(
	"n",
	"<leader>bp",
	":BufferLinePickClose<CR>",
	{ silent = true, desc = "选择关闭标签 (Pick Close) --插件(Bufferline)" }
)
vim.keymap.set(
	"n",
	"<leader>bc",
	":BufferLineCloseOthers<CR>",
	{ silent = true, desc = "关闭其他标签 (Close Others) --插件(Bufferline)" }
)
vim.keymap.set(
	"n",
	"<leader>bd",
	":bdelete<CR>",
	{ silent = true, desc = "删除当前缓冲区 (Delete Buffer) --插件(Bufferline)" }
)

-- Hop 插件快捷键
vim.keymap.set("n", "ff", "<Cmd>HopWord<CR>", { silent = true, desc = "单词跳转 (Hop Word) --插件(Hop)" })

-- Lspsaga 插件快捷键
vim.keymap.set("n", "<F2>", ":Lspsaga rename<CR>", { desc = "全局重命名变量 (Rename) --插件(Lspsaga)" })
vim.keymap.set(
	"n",
	"<leader>n",
	":Lspsaga diagnostic_jump_next<CR>",
	{ desc = "跳转到下一个诊断 (Next Diagnostic) --插件(Lspsaga)" }
)

vim.keymap.set(
	"n",
	"<leader>p",
	":Lspsaga diagnostic_jump_prev<CR>",
	{ desc = "跳转到上一个诊断 (Prev Diagnostic) --插件(Lspsaga)" }
)

-- Conform 插件快捷键
vim.keymap.set("n", "<leader>f", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "格式化代码 (Format Code) --插件(Conform)" })

-- Snacks Terminal 插件快捷键
vim.keymap.set(
	"t",
	"jj",
	function()
		if vim.bo.filetype == "yazi" then
			return vim.NIL
		end
		return vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
	end,
	{ expr = true, noremap = true, silent = true, desc = "退出终端插入模式 (Exit Term Insert) --插件(Snacks)" }
)

vim.keymap.set("t", "<Esc>", function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
	vim.defer_fn(function()
		if vim.bo.buftype == "terminal" then
			vim.cmd("bd!")
		end
	end, 20)
end, { noremap = true, silent = true, desc = "关闭终端 (Close Terminal) --插件(Snacks)" })
