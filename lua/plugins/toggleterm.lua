---@diagnostic disable: undefined-global
return {
	"akinsho/toggleterm.nvim",
	version = "*",
	event = "VeryLazy",
	cmd = "ToggleTerm",
	opts = {
		-- 垂直分屏占 40% 列宽，其它方向固定 20 行
		size = function(term)
			if term.direction == "vertical" then
				return vim.o.columns * 0.4
			end
			return 20
		end,
		direction = "vertical",
		float_opts = {
			border = "single",
			width = function()
				return math.floor(vim.o.columns * 0.6)
			end,
			height = function()
				return math.floor(vim.o.lines * 0.6)
			end,
			winblend = 3,
			title_pos = "center",
		},
	},
}
