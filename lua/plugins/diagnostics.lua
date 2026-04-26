---@diagnostic disable: undefined-global
return {
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
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
				style = "minimal",
				border = "rounded",
				source = true,
				header = "",
				prefix = "",
			},
			jump_opts = {
				focus = true,
				win = function(diag)
					return {
						relative = "cursor",
						row = diag.lnum + 1,
						col = diag.col,
					}
				end,
			},
		})
	end,
}

