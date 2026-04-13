---@diagnostic disable: undefined-global
return {
	"stevearc/conform.nvim",
	event = "VeryLazy",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "black" },
			c = { "clang-format" }, -- 修正为 Mason 中的名称
			cpp = { "clang-format" }, -- 修正为 Mason 中的名称
			sql = { "sql-formatter" },
			["_"] = { "trim_whitespace" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
	},
}
