-- CodeCompanion.nvim - AI 编程助手
-- https://github.com/olimorris/codecompanion.nvim
---@diagnostic disable: undefined-global

return {
	"olimorris/codecompanion.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"lalitmee/codecompanion-spinners.nvim",
		{
			"HakonHarnes/img-clip.nvim",
			opts = {
				default = {
					dir_path = vim.fn.stdpath("data") .. "/codecompanion/images",
				},
				filetypes = {
					codecompanion = {
						prompt_for_file_name = false,
						template = "[Image]($FILE_PATH)",
						use_absolute_path = true,
					},
				},
			},
			init = function()
				local group = vim.api.nvim_create_augroup("codecompanion_image_paste", { clear = true })

				vim.api.nvim_create_autocmd("FileType", {
					desc = "CodeCompanion 聊天缓冲区图片粘贴支持",
					group = group,
					pattern = "codecompanion",
					callback = function(ev)
						vim.keymap.set({ "n", "i" }, "<C-v>", "<Cmd>PasteImage<CR>", {
							buffer = ev.buf,
							desc = "[CodeCompanion] 粘贴剪贴板图片",
						})
					end,
				})
			end,
		},
	},

	opts = {
		display = {
			chat = {
				fold_context = true,
				show_reasoning = false,
				intro_message = "欢迎使用 CodeCompanion ✨！按 ? 查看选项",
				icons = {
					chat_context = " ",
				},
				window = {
					width = 0.4,
					opts = {
						number = false,
						relativenumber = false,
						signcolumn = "no",
						cursorline = true,
						winbar = "",
					},
				},
			},
		},

		interactions = {
			-- ACP 适配器不支持后台交互（仅支持 HTTP），而本配置只用 claude_code，
			-- 因此关闭全部后台调用，避免聊天标题生成与工具评审触发警告。
			background = {
				chat = {
					opts = {
						enabled = false,
					},
				},
				gates = {
					judge = {
						enabled = false,
					},
				},
			},

			chat = {
				adapter = "claude_code",
				roles = {
					llm = "CodeCompanion",
				},
				keymaps = {
					-- 这两个快捷键只控制 CodeCompanion 内置工具，不控制 ACP 权限。
					clear_approvals = false,
					yolo_mode = false,
					cycle_acp_mode = {
						modes = { n = "<S-Tab>" },
						description = "[Agent] 循环切换 ACP 权限模式",
						callback = function(chat)
							local acp_mode = require("plugins.codecompanion.acp_mode")
							local mode, err = acp_mode.cycle(chat)
							if not mode then
								return vim.notify(err, vim.log.levels.WARN)
							end

							vim.notify("ACP Mode → " .. mode.name, vim.log.levels.INFO)
							if chat.update_metadata then
								chat:update_metadata()
							end
						end,
					},
				},
			},

			inline = {
				adapter = "claude_code",
			},

			cmd = {
				adapter = "claude_code",
			},
		},

		extensions = {
			spinner = {
				enabled = true,
				opts = {
					style = "lualine",
				},
			},
		},

		-- Claude Code 会自行加载 CLAUDE.md/AGENTS.md，避免重复注入上下文。
		rules = {
			opts = {
				chat = {
					autoload = false,
				},
			},
		},

		adapters = {
			http = {
				opts = {
					show_presets = false,
				},
			},

			-- ACP: Agent Client Protocol
			acp = {
				opts = {
					show_presets = false,
				},
				-- 注意: 这里看似冗余，实则是必需的。
				-- show_presets = false 时 init.lua:adapter_config 会用用户表整个替换
				-- config.adapters.acp(而不是合并)，内置 preset 条目会被全部丢弃，
				-- 包括 claude_code 本身。所以必须在这里显式重新注册，
				-- 否则 adapter = "claude_code" 解析失败(会 fallback 到 HTTP 报
				-- "Adapter not found: claude_code")。
				claude_code = function()
					return require("codecompanion.adapters").extend("claude_code", {})
				end,
			},
		},

		opts = {
			log_level = "ERROR",
			language = "简体中文",
		},
	},
}
