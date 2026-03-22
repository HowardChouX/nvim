-- lua/plugins/blink.lua
-- Blink.cmp 配置 - 基于 LazyVim 推荐配置优化
---@diagnostic disable: undefined-global
return {
	"saghen/blink.cmp",
	version = "*",
	event = "VeryLazy",
	dependencies = {
		"L3MON4D3/LuaSnip",
	},
	opts = {
		-- Snippet 配置
		snippets = {
			preset = "default",
		},

		-- 外观配置
		appearance = {
			use_nvim_cmp_as_default = false,
			nerd_font_variant = "mono",
			-- kind 图标 (使用 Nerd Fonts)
			kind_icons = {
				Text = "󰉿",
				Method = "󰆧",
				Function = "󰊕",
				Constructor = "󰐩",
				Field = "󰇽",
				Variable = "󰂡",
				Class = "󰠱",
				Interface = "󰡱",
				Module = "󰏗",
				Property = "󰜢",
				Unit = "󰑭",
				Value = "󰎠",
				Enum = "󰒻",
				Keyword = "󰌋",
				Snippet = "󰃐",
				Color = "󰏘",
				File = "󰈙",
				Reference = "󰈇",
				Folder = "󰉋",
				EnumMember = "󰕳",
				Constant = "󰏿",
				Struct = "󰙅",
				Event = "󱐋",
				Operator = "󰆕",
				TypeParameter = "󰅲",
			},
		},

		-- 补全配置
		completion = {
			accept = {
				auto_brackets = {
					enabled = true,
				},
			},
			menu = {
				draw = {
					treesitter = { "lsp" },
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
			},
			ghost_text = {
				enabled = true,
			},
			list = {
				selection = {
					preselect = true,
					auto_insert = true,
				},
			},
			trigger = {
				show_on_trigger_character = true,
			},
		},

		-- Sources 配置
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			providers = {
				lsp = {
					name = "lsp",
					enabled = true,
					module = "blink.cmp.sources.lsp",
					score_offset = 0,
				},
				snippets = {
					name = "snippets",
					enabled = true,
					module = "blink.cmp.sources.snippets",
					score_offset = 10,
				},
				buffer = {
					name = "buffer",
					enabled = true,
					module = "blink.cmp.sources.buffer",
					score_offset = -5,
				},
				path = {
					name = "path",
					enabled = true,
					module = "blink.cmp.sources.path",
					score_offset = -10,
				},
			},
			-- 为 codecompanion 添加 per_filetype 源
			per_filetype = {
				codecompanion = { "codecompanion" },
			},
		},

		-- 命令行补全
		cmdline = {
			enabled = true,
			keymap = {
				preset = "cmdline",
				["<Right>"] = false,
				["<Left>"] = false,
			},
			completion = {
				list = { selection = { preselect = false } },
				menu = {
					auto_show = function(ctx)
						return vim.fn.getcmdtype() == ":"
					end,
				},
				ghost_text = { enabled = true },
			},
		},

		-- 键位映射
		keymap = {
			preset = "default",
			["<Tab>"] = {
				"select_and_accept",
				"snippet_forward",
				"fallback",
			}, -- Tab 接受补全或前进 snippet，否则插入制表符
			["<S-Tab>"] = { "select_next", "snippet_backward", "fallback" }, -- Shift + Tab 上一个补全项或后退 snippet
			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
		},

		-- Fuzzy 配置
		fuzzy = {
			implementation = "rust",
		},
	},
}
