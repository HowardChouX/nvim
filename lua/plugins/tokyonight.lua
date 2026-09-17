-- 告诉 Lua 语言服务器 vim 是全局变量
---@diagnostic disable: undefined-global
return {
	"folke/tokyonight.nvim",
	lazy = false, -- 禁用懒加载否则lualine渲染容易失败
	priority = 1000, -- 高优先级
	opts = {
		style = "moon",
	},
	config = function(_, opts)
		require("tokyonight").setup(opts)
		vim.cmd("colorscheme tokyonight")
	end,
}
