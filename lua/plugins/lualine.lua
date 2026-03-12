return {
	"nvim-lualine/lualine.nvim",
	event = "UIenter", -- 界面渲染完成后触发
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = function()
		---@diagnostic disable: undefined-global
		local function lsp_status_short()
			local clients = vim.lsp.get_clients({ bufnr = 0 })

			if #clients == 0 then
				return "?"
			end
			return " " .. #clients
		end

		local function lsp_diagnostics()
			if not vim.diagnostic then
				return ""
			end

			local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
			local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

			local result = ""
			if errors > 0 then
				result = result .. " " .. errors
			end
			if warnings > 0 then
				if #result > 0 then
					result = result .. " "
				end
				result = result .. " " .. warnings
			end

			return result
		end

		return {
			options = {
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				globalstatus = true, -- 使用全局状态栏，减少高度
				disabled_filetypes = {
					statusline = { "DressingSelect", "snacks_terminal" },
					winbar = { "DressingSelect", "snacks_terminal" },
				},
			},
			extensions = {},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = {
					-- CodeCompanion Spinner: 在 AI 思考时显示动画
					function()
						local ok_lualine_spinner, lualine_spinner = pcall(require, "codecompanion._extensions.spinner.styles.lualine")
						if ok_lualine_spinner then
							local component = lualine_spinner.get_lualine_component()
							if component[1] then
								return component[1]()
							end
						end
						return ""
					end,
					lsp_status_short,
					lsp_diagnostics,
					"filesize",
					"encoding",
					"filetype",
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { lsp_status_short, "location" },
				lualine_y = {},
				lualine_z = {},
			},
		}
	end,
	config = function(_, opts)
		require("lualine").setup(opts)

		-- 初始化 CodeCompanion Lualine Spinner
		local ok_lualine_spinner, lualine_spinner = pcall(require, "codecompanion._extensions.spinner.styles.lualine")
		if ok_lualine_spinner then
			lualine_spinner.setup()
		end

		vim.api.nvim_create_augroup("LualineLSP", { clear = true })
		vim.api.nvim_create_autocmd("LspAttach", {
			group = "LualineLSP",
			callback = function()
				vim.defer_fn(function()
					require("lualine").refresh()
				end, 100)
			end,
		})

		vim.api.nvim_create_autocmd("LspDetach", {
			group = "LualineLSP",
			callback = function()
				require("lualine").refresh()
			end,
		})

		vim.api.nvim_create_autocmd("DiagnosticChanged", {
			group = "LualineLSP",
			callback = function()
				require("lualine").refresh()
			end,
		})
	end,
}
