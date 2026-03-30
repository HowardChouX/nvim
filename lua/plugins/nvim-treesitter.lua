-- 告诉 Lua 语言服务器 vim 是全局变量
---@diagnostic disable: undefined-global
return {
	"nvim-treesitter/nvim-treesitter",
	event = "VeryLazy",
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
			"lua",
			"vim",
			"vimdoc",
			"toml",
			"python",
			"cpp", -- C++
			"c", -- C
			"json",
			"yaml",
			"bash",
			"markdown",
			"markdown_inline",
			"html",
			"css",
			"javascript",
			"typescript",
			"tsx",
			"regex",
			"go",
			"java",
			"rust",
			"query",
		},
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		indent = {
			enable = true,
		},
	},
}
