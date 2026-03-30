-- plugins/yazi.lua
---@diagnostic disable: undefined-global
return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },

	-- 禁用 netrw
	init = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
	end,

	keys = {
		{ "<leader>e", "<cmd>Yazi<cr>", desc = "打开文件管理器 (Open yazi)" },
	},

	opts = {
		open_for_directories = true, -- 用 yazi 打开目录（替代 netrw）
		open_file = {
			quit_on_open = false,
		},
	},
}
