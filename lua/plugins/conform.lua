---@diagnostic disable: undefined-global
return {
	"stevearc/conform.nvim",
	event = "VeryLazy",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			c = { "clang_format" },
			cpp = { "clang_format" },
			sql = { "sqlfluff" },
			["_"] = { "trim_whitespace" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
	},
}
