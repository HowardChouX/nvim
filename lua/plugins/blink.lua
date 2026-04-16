---@diagnostic disable: undefined-global, undefined-doc-name
return {
	"saghen/blink.cmp",
	build = "cargo build --release",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		"rafamadriz/friendly-snippets",
		"saghen/blink.compat",
	},
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		snippets = {
			preset = "default",
		},
		appearance = {
			use_nvim_cmp_as_default = false,
			nerd_font_variant = "mono",
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

		completion = {
			accept = { auto_brackets = { enabled = true } },
			menu = {
				draw = {
					treesitter = { "lsp", "buffer", "snippets", "path" },
					columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 350,
				window = { border = "rounded" },
			},
			ghost_text = { enabled = false },
			list = {
				selection = {
					preselect = true,
					auto_insert = false,
				},
			},
			trigger = { show_on_trigger_character = true },
		},

		signature = { enabled = true },

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			providers = {
				lsp = { score_offset = 5 },
				buffer = { score_offset = 2 },
				path = { score_offset = 0 },
				snippets = { score_offset = 3 },
			},
		},

		cmdline = {
			enabled = true,
			keymap = { preset = "cmdline" },
			completion = {
				list = { selection = { preselect = false } },
				menu = {
					auto_show = function()
						return vim.fn.getcmdtype() == ":"
					end,
				},
				ghost_text = { enabled = true },
			},
		},

		keymap = {
			preset = "super-tab",
			["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
			["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
			["<Enter>"] = { "accept", "fallback" },
			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
		},
	},
}
