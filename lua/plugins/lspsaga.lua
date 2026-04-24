-- LSP 增强插件：提供符号查找、代码操作、悬停文档、诊断显示、函数签名等功能
-- 告诉 Lua 语言服务器 vim 是全局变量
---@diagnostic disable: undefined-global
return {
	"nvimdev/lspsaga.nvim",
	event = "LspAttach",
	opts = {
		finder = {
			keys = {
				toggle_or_open = "<CR>",
			},
		},
		symbol_in_winbar = {
			enable = true,
			separator = " > ",
			hide_keyword = true,
			show_file = true,
			delay = 300,
		},
		-- 禁用 lightbulb（小灯泡），避免提示造成的屏幕抖动
		lightbulb = {
			enable = false,
		},
	},
}
