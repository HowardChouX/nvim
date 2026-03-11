-- 告诉 Lua 语言服务器 vim 是全局变量
---@diagnostic disable: undefined-global
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		terminal = {
			-- 终端配置
			win = {
				position = "float",
				width = 0.8,
				height = 0.8,
				border = "double",
				winblend = 0,
			},
		},
	},
	keys = {
		{ "<C-t>", function() Snacks.terminal.toggle() end, desc = "切换终端 (Toggle Terminal)", mode = { "n", "t" } },
	},
}