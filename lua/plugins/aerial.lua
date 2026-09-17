---@diagnostic disable: undefined-global
return {
	"stevearc/aerial.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	event = "VeryLazy",
	opts = {
		-- 优先使用treesitter，回退到LSP
		backends = { "treesitter", "lsp", "markdown" },

		-- 窗口布局设置
		layout = {
			default_direction = "prefer_left",
			win_opts = {
				winhl = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
				cursorline = true, -- 显示光标行
			},
		},
		close_automatic_events = { "unsupported" },

		-- 简化的快捷键映射
		keymaps = {
			["<CR>"] = "actions.jump",
			["j"] = "actions.next",
			["k"] = "actions.prev",
			["q"] = "actions.close",
			["<Tab>"] = "actions.tree_toggle",
			["o"] = "actions.tree_toggle",
		},

		icons = {
			["Collapsed"] = "",
			["Expanded"] = "",
			Array = "󰅪",
			Boolean = "",
			Class = "󰠱",
			Constant = "󰏿",
			Constructor = "",
			Enum = "󰕘",
			Function = "󰊕",
			Interface = "󰜰",
			Method = "󰊕",
			Module = "󰆧",
			Struct = "󰙅",
			Variable = "󰆧",
		},

		show_guides = true,
	},
}
