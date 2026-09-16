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

		vim.api.nvim_create_augroup("LualineLSP", { clear = true })
		vim.api.nvim_create_autocmd({ "LspAttach", "DiagnosticChanged" }, {
			group = "LualineLSP",
			callback = function()
				vim.defer_fn(function()
					require("lualine").refresh()
				end, 100)
			end,
		})

		-- ACP 权限模式变化不会产生任何 Vim 事件，必须显式刷新状态栏
		-- 同时覆盖聊天的创建/关闭，让指示器及时出现与消失
		-- 用 force: 默认的 refresh() 是入队等定时器，按键后可能延迟约 1 秒才体现
		vim.api.nvim_create_augroup("LualineACP", { clear = true })
		vim.api.nvim_create_autocmd("User", {
			group = "LualineACP",
			pattern = {
				"CodeCompanionChatACPConfigChanged",
				"CodeCompanionChatCreated",
				"CodeCompanionChatClosed",
				"CodeCompanionACPConnected",
			},
			callback = function()
				vim.defer_fn(function()
					require("lualine").refresh({ force = true })
				end, 50)
			end,
		})
	end,
}
