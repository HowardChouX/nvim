---@diagnostic disable: undefined-global
return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		vim.diagnostic.config({
			virtual_text = {
				prefix = "●",
				source = "if_many",
			},
			update_in_insert = false,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅙 ",
					[vim.diagnostic.severity.WARN] = "󰀪 ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
					[vim.diagnostic.severity.INFO] = "󰋽 ",
				},
			},
			underline = true,
			severity_sort = true,
			float = {
				focusable = false,
				border = "rounded",
				source = true,
				header = "",
				prefix = "",
			},
			jump = {
				on_jump = function(_, bufnr)
					vim.diagnostic.open_float({
						bufnr = bufnr,
						scope = "cursor",
						focus = false,
					})
				end,
			},
		})
	end,
}
