---@diagnostic disable: undefined-global
return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
	opts = {
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
			},
			hover = { silent = true },
			signature = {
				-- 由 blink.cmp 统一显示签名，避免重复浮窗。
				enabled = false,
			},
		},
		routes = {
			{
				filter = {
					event = "msg_show",
					any = {
						{ find = "%d+L, %d+B" },
						{ find = "; after #%d+" },
						{ find = "; before #%d+" },
					},
				},
				view = "mini",
			},
			{
				filter = {
					event = "notify",
					find = "No information available",
				},
				opts = { skip = true },
			},
			{
				filter = {
					event = "notify",
					find = "already referenced",
				},
				opts = { skip = true },
			},
			{
				filter = {
					event = "notify",
					find = "Missing frontmatter",
				},
				opts = { skip = true },
			},
		},
		presets = {
			bottom_search = true,
			command_palette = true,
			long_message_to_split = true,
		},
		views = {
			notify = {
				anchor = "NE",
				position = { row = 1, col = -1 },
				size = { width = 40, height = "auto" },
				border = "none",
				zindex = 50,
				footer = "按 <leader>dn 关闭",
				win_options = {
					winblend = 20,
				},
			},
			mini = {
				position = { row = -2, col = -1 },
				timeout = 150,
				size = { width = 15, height = 1 },
				border = "none",
				zindex = 60,
				win_options = {
					winblend = 30,
					winhighlight = {
						Normal = "NoiceMini",
						IncSearch = "",
						Search = "",
					},
				},
			},
		},
		cmdline = {
			format = {
				cmdline = { pattern = "^:", icon = "󰌘", lang = "vim" },
				search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
				search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
				filter = { pattern = "^:%s*!", icon = "$", lang = "vim" },
				lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
				help = { pattern = "^:%s*he?l?p?%s+", icon = "󰌖" },
			},
		},
	},
	config = function(_, opts)
		if vim.o.filetype == "lazy" then
			vim.cmd([[messages clear]])
		end
		require("noice").setup(opts)
	end,
}
