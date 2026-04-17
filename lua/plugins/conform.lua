---@diagnostic disable: undefined-global
return {
	"stevearc/conform.nvim",
	event = "VeryLazy",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "black" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			sql = { "sql-formatter" },
			java = { "google-java-format" },
			["_"] = { "trim_whitespace" },
		},
		format_on_save = {
			timeout_ms = 1000,
			lsp_fallback = true,
		},
	},
}
