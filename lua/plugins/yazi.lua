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

	opts = {
		open_for_directories = true,
		floating_window_scaling_factor = 0.9,
		yazi_floating_window_border = "rounded",
		highlight_hovered_buffers_in_same_directory = true,

		integrations = {
			bufdelete_implementation = "bundled-snacks",
		},
	},
}
