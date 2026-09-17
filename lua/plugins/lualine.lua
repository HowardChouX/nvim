return {
	"nvim-lualine/lualine.nvim",
	event = "UIenter", -- 界面渲染完成后触发
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"lalitmee/codecompanion-spinners.nvim",
	},
	opts = function()
		---@diagnostic disable: undefined-global
		local acp_mode = require("plugins.codecompanion.acp_mode")
		local codecompanion_spinner = require("codecompanion._extensions.spinner.styles.lualine")

		local function lsp_status_short()
			local clients = vim.lsp.get_clients({ bufnr = 0 })

			if #clients == 0 then
				return ""
			end
			return " " .. #clients
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
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff" },
				lualine_c = { "filename" },
				lualine_x = {
					codecompanion_spinner.get_lualine_component(),
					{
						acp_mode.lualine,
						color = acp_mode.lualine_color,
						separator = { left = "", right = "" },
						padding = { left = 1, right = 1 },
					}, -- 当前 ACP 权限模式徽标 (无会话时自动隐藏)
					lsp_status_short,
					"filesize",
					"encoding",
					"filetype",
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_c = { "filename" },
				lualine_x = { "location" },
			},
		}
	end,
	config = function(_, opts)
		require("lualine").setup(opts)
		local refresh_pending = false
		local function refresh_lualine(delay)
			if refresh_pending then
				return
			end
			refresh_pending = true
			vim.defer_fn(function()
				refresh_pending = false
				if package.loaded["lualine"] then
					require("lualine").refresh({ force = true })
				end
			end, delay)
		end

		vim.api.nvim_create_augroup("LualineLSP", { clear = true })
		vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
			group = "LualineLSP",
			callback = function()
				refresh_lualine(50)
			end,
		})

		-- 权限徽标与 Spinner 都由 CodeCompanion User 事件驱动。
		vim.api.nvim_create_augroup("LualineACP", { clear = true })
		vim.api.nvim_create_autocmd("User", {
			group = "LualineACP",
			pattern = "CodeCompanion*",
			callback = function()
				refresh_lualine(50)
			end,
		})
	end,
}
