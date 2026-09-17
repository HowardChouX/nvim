return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		-- 自定义 Dashboard action 函数
		local dashboard_actions = {
			telescope_oldfiles = function()
				require("telescope.builtin").oldfiles()
			end,
			telescope_find_files = function()
				require("telescope.builtin").find_files()
			end,
		}

		require("dashboard").setup({
			theme = "hyper",
			config = {
				-- [关键修改] 控制 UI 元素的隐藏行为
				hide = {
					statusline = false, -- 如果设为 true，则在 dashboard 隐藏底部状态栏
					tabline = false, -- [重要] 设为 false，就不会隐藏顶部的 Buffer 栏了
					winbar = false, -- 是否隐藏 winbar
				},

				header = {
					"███████╗ █████╗ ███████╗██╗   ██╗",
					"██╔════╝██╔══██╗██╔════╝╚██╗ ██╔╝",
					"█████╗  ███████║███████╗ ╚████╔╝ ",
					"██╔══╝  ██╔══██║╚════██║  ╚██╔╝  ",
					"███████╗██║  ██║███████║   ██║   ",
					"╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝   ",
				},
				shortcut = {
					{ desc = "󰈙 New File", group = "@property", action = "enew", key = "n" },
					{
						desc = "󰄕 Recent Files",
						group = "@property",
						action = dashboard_actions.telescope_oldfiles,
						key = "r",
					},
					{
						desc = "󰐕 Find File",
						group = "@property",
						action = dashboard_actions.telescope_find_files,
						key = "f",
					},
					{ desc = "󰊳 Update", group = "@property", action = "Lazy sync", key = "u" },
					{ desc = "󰉓 Settings", group = "@property", action = "e ~/.config/nvim/init.lua", key = "s" },
					{ desc = "󰐒 Quit", group = "@property", action = "qa", key = "q" },
				},
				project = {
					enable = true,
					limit = 8,
					action = dashboard_actions.telescope_find_files,
				},
				mru = {
					enable = true,
					limit = 10,
				},
				footer = {},
			},
		})
	end,
}
