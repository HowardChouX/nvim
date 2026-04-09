---@diagnostic disable: undefined-global
return {
	"akinsho/toggleterm.nvim",
	version = "*",
	event = "VeryLazy",
	opts = {
		-- 终端尺寸：垂直分屏时占 0.4 列宽
		size = function(term)
			if term.direction == "vertical" then
				return vim.o.columns * 0.4
			end
			return 20
		end,
		-- 打开关闭
		open_mapping = [[<C-t>]],
		-- 隐藏行号
		hide_numbers = true,
		-- 自动切换目录
		autochdir = false,
		-- 阴影终端
		shade_terminals = true,
		shading_factor = -30,
		shading_ratio = -3,
		-- 启动时进入插入模式
		start_in_insert = true,
		-- 插入模式下快捷键是否生效
		insert_mappings = true,
		-- 终端窗口内快捷键是否生效
		terminal_mappings = true,
		-- 记住窗口大小
		persist_size = true,
		-- 记住模式
		persist_mode = true,
		-- 默认方向：垂直分屏
		direction = "vertical",
		-- 进程退出后关闭窗口
		close_on_exit = true,
		-- 不清除环境变量
		clear_env = false,
		-- shell
		shell = vim.o.shell,
		-- 自动滚动
		auto_scroll = true,
		-- 浮动窗口配置
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
		-- winbar 配置
		winbar = {
			enabled = false,
		},
		-- 响应式配置：当屏幕宽度小于 135 列时，垂直终端自动转为水平
		responsiveness = {
			horizontal_breakpoint = 135,
		},
	},
	config = function(_, opts)
		require("toggleterm").setup(opts)
	end,
}
