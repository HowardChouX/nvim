-- CodeCompanion.nvim - AI 编程助手
-- https://github.com/olimorris/codecompanion.nvim
---@diagnostic disable: undefined-global
return {
	"olimorris/codecompanion.nvim",
	version = "^19.0.0",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"ravitemer/mcphub.nvim", -- MCP 服务器集成扩展
	},
	opts = {
		-- ===== 触发前缀配置 =====
		triggers = {
			acp_slash_commands = "\\",
			editor_context = "#",
			slash_commands = "/",
			tools = "@",
		},

		-- ===== 显示配置 =====
		display = {
			action_palette = {
				width = 95,
				height = 10,
				prompt = "Prompt ",
				provider = "default",
				opts = {
					show_preset_actions = true,
					show_preset_prompts = true,
					show_prompt_library_builtins = true, -- 显示内置提示
					title = "CodeCompanion actions",
				},
			},
			-- 差异显示配置
			diff = {
				enabled = true,
				word_highlights = {
					additions = true,
					deletions = true,
				},
			},
			-- 聊天窗口配置
			chat = {
				auto_scroll = true, -- 响应流式输出时自动滚动
				fold_context = true, -- 折叠上下文以节省空间
				fold_reasoning = true, -- 流式完成后折叠推理内容
				show_reasoning = true, -- 显示推理输出
				-- 其他 UI 选项
				intro_message = "欢迎使用 CodeCompanion ✨！按 ? 查看选项",
				separator = "─", -- 消息之间的分隔符
				show_context = true, -- 显示上下文内容
				show_header_separator = false, -- 不显示标题分隔符（使用外部 markdown 插件时建议关闭）
				show_settings = false, -- 不在顶部显示 LLM 设置
				show_token_count = true, -- 显示每个响应的 token 数
				show_tools_processing = true, -- 显示工具执行的加载消息
				start_in_insert_mode = false, -- 以普通模式打开聊天缓冲区
				-- 自定义图标
				icons = {
					buffer_sync_all = "󰪴 ",
					buffer_sync_diff = " ",
					chat_context = " ",
					chat_fold = " ",
					tool_pending = " ",
					tool_in_progress = " ",
					tool_failure = " ",
					tool_success = " ",
				},
				window = {
					width = 0.4,
					height = 0.9,
					relative = "editor",
					opts = {
						number = false,
						relativenumber = false,
						signcolumn = "no",
						cursorline = true,
						winbar = "",
					},
				},
			},
			-- 内联助手布局配置
			inline = {
				layout = "vertical", -- vertical|horizontal|tab|buffer
			},
		},


		-- ===== 交互配置 =====
		interactions = {
			chat = {
				adapter = "claude_code", -- ACP 适配器
				-- 变量配置 (MCP 扩展需要)
				variables = {},
				-- 角色名称配置
				roles = {
					llm = function(adapter)
						return " " .. adapter.formatted_name
					end,
					user = "me",
				},
				opts = {
					completion_provider = "blink",
				},
				-- 编辑器上下文配置 (使用 #buffer 等)
				editor_context = {
					["buffer"] = {
						opts = {
							default_params = "diff", -- 默认同步缓冲区差异
						},
					},
				},
				-- Slash 命令配置 (在聊天中使用 /file 等)
				slash_commands = {
					["file"] = {
						opts = {
							provider = "telescope", -- 可选: "default", "telescope", "fzf_lua", "mini_pick"
							contains_code = true,
						},
					},
					["buffer"] = {
						opts = {
							provider = "telescope",
							contains_code = true,
						},
					},
					["help"] = {
						opts = {
							provider = "telescope",
							contains_code = true,
						},
					},
				},
				-- 工具配置 (在聊天中使用 @工具名 调用)
				tools = {
					-- 全局工具选项
					opts = {
						auto_submit_errors = true, -- 自动将错误发送给 LLM
						auto_submit_success = true, -- 自动将成功输出发送给 LLM
						default_tools = {}, -- 默认加载的工具 (留空，按需使用 @tool 调用)
					},
					-- 内置工具条件启用
					["grep_search"] = {
						enabled = function()
							return vim.fn.executable("rg") == 1
						end,
					},
					-- 安全审批配置: 运行命令需要用户批准
					["run_command"] = {
						opts = {
							allowed_in_yolo_mode = false, -- YOLO 模式下也需要批准
						},
					},
					-- 安全审批配置: 编辑文件需要用户批准
					["insert_edit_into_file"] = {
						opts = {
							allowed_in_yolo_mode = false,
						},
					},
					-- 工具组: 全功能代码助手
					groups = {
						["full_stack_dev"] = {
							description = "全栈开发助手 - 可编辑文件、运行命令、搜索代码",
							system_prompt = "你是一位全栈开发专家，可以编辑文件、运行命令和搜索代码。请谨慎操作，确保在运行危险命令前询问用户。",
							tools = {
								"insert_edit_into_file",
								"read_file",
								"run_command",
								"grep_search",
							},
							opts = {
								collapse_tools = true,
							},
						},
					},
				},
			},
			inline = {
				-- HTTP 适配器配置 (inline 仅支持 HTTP 适配器)
				adapter = "anthropic",
				-- 内联助手快捷键 (配置在 keymap.lua)
				keymaps = vim.g.codecompanion_inline_keymaps,
			},
			-- 后台回调配置 (用于异步任务如生成聊天标题)
			background = {
				adapter = "anthropic",
				chat = {
					callbacks = {
						["on_ready"] = {
							actions = {
								"interactions.background.builtin.chat_make_title",
							},
							enabled = true,
						},
					},
					opts = {
						enabled = true,
					},
				},
			},
			-- 命令行交互配置
			cmd = {
				adapter = {
					name = "anthropic",
					model = os.getenv("ANTHROPIC_MODEL"),
				},
			},
		},

		-- ===== 规则配置 =====
		rules = {
			-- 默认规则组 (常用规则文件)
			default = {
				description = "通用规则文件集合",
				files = {
					".cursorrules",
					".rules",
					".windsurfrules",
					".github/copilot-instructions.md",
					"AGENT.md",
					"AGENTS.md",
					{ path = "CLAUDE.md", parser = "claude" },
					{ path = "CLAUDE.local.md", parser = "claude" },
					{ path = "~/.claude/CLAUDE.md", parser = "claude" },
				},
				is_preset = true,
			},
			-- Claude Code 专用规则组
			claude = {
				description = "Claude Code 规则",
				parser = "claude",
				files = {
					"CLAUDE.md",
					"CLAUDE.local.md",
					"~/.claude/CLAUDE.md",
				},
			},
			opts = {
				chat = {
					autoload = "default", -- 自动加载默认规则组
					enabled = true,
				},
			},
		},

		-- ===== 适配器配置 =====
		adapters = {
			-- HTTP 适配器 (用于 inline/cmd/background)
			http = {
				-- OpenAI 兼容格式适配器
				anthropic = function()
					-- 从设置文件读取配置
					local settings_path = vim.fn.expand("~/.claude/settings.json")
					local settings_file = io.open(settings_path, "r")
					local base_url, api_key, model

					if settings_file then
						local content = settings_file:read("*a")
						settings_file:close()
						local ok, settings = pcall(vim.json.decode, content)
						if ok and settings and settings.env then
							base_url = settings.env.ANTHROPIC_BASE_URL
							api_key = settings.env.ANTHROPIC_API_KEY
							model = settings.env.ANTHROPIC_MODEL
						end
					end

					-- 回退到环境变量
					base_url = base_url or os.getenv("ANTHROPIC_BASE_URL")
					api_key = api_key or os.getenv("ANTHROPIC_API_KEY")
					model = model or os.getenv("ANTHROPIC_MODEL")

					if not base_url or not api_key then
						return nil
					end

					base_url = base_url:gsub("/$", "")
					return require("codecompanion.adapters").extend("openai_compatible", {
						env = {
							url = base_url,
							api_key = api_key,
						},
						schema = {
							model = {
								default = model,
							},
						},
					})
				end,

				-- 适配器选项
				opts = {
					show_presets = false, -- 隐藏预设适配器，只显示用户定义的
					show_model_choices = true, -- 切换适配器时显示模型选择
				},
			},

			-- ACP 适配器 (用于 chat)
			acp = {
				-- Claude Code ACP 适配器
				-- 环境变量从 /etc/claude-code/managed-settings.json 或 ~/.claude/settings.json 读取
				claude_code = function()
					return require("codecompanion.adapters").extend("claude_code", {
						env = {
							ANTHROPIC_API_KEY = "ANTHROPIC_API_KEY",
						},
						defaults = {
							model = os.getenv("ANTHROPIC_MODEL"),
							mcpServers = "inherit_from_config",
						},
					})
				end,
			},
		},

		-- ===== 扩展配置 =====
		extensions = {
			mcphub = {
				callback = "mcphub.extensions.codecompanion",
				opts = {
					make_vars = true, -- 创建 MCP 变量
					make_slash_commands = true, -- 创建 MCP slash 命令
					show_result_in_chat = true, -- 在聊天中显示结果
				},
			},
		},

		-- ===== MCP 服务器配置 =====
		mcp = {
			servers = {
				-- 文件系统访问
				["filesystem"] = {
					cmd = { "npx", "-y", "@modelcontextprotocol/server-filesystem" },
					roots = function()
						return {
							{ name = "config", uri = vim.fn.expand("~/.config") },
							{ name = "project", uri = vim.fn.getcwd() },
						}
					end,
				},
				-- 顺序思考
				["sequential-thinking"] = {
					cmd = { "npx", "-y", "@modelcontextprotocol/server-sequential-thinking" },
				},
				-- 网络搜索
				["tavily-mcp"] = {
					cmd = { "npx", "-y", "tavily-mcp@latest" },
					env = {
						TAVILY_API_KEY = os.getenv("TAVILY_API_KEY"),
					},
				},
			},
			opts = {
				-- 默认启动的服务器
				default_servers = { "sequential-thinking" },
			},
		},
	},

	-- ===== 快捷键配置 =====
	keys = {
		-- Action Palette (j + <tab>)
		{ "j", function()
			local char = vim.fn.nr2char(vim.fn.getchar())
			if char == "\t" then
				vim.cmd("CodeCompanionActions")
			else
				vim.api.nvim_feedkeys("j" .. char, "n", false)
			end
		end, mode = { "n", "v" }, desc = "CodeCompanion Actions (j+tab)" },
	},

	-- ===== 回调函数配置 (通过 autocmd 注册) =====
	init = function()
		-- Token 限制检查回调
		vim.api.nvim_create_autocmd("User", {
			pattern = "CodeCompanionChatCreated",
			callback = function(args)
				local chat = require("codecompanion").buf_get_chat(args.data.bufnr)

				-- 提交前检查 token 限制
				chat:add_callback("on_before_submit", function(c, info)
					local tokens = require("codecompanion.utils.tokens")
					local token_count = tokens.calculate(vim.inspect(c.messages))
					local context_limit = 128000

					if token_count > context_limit then
						vim.notify(
							string.format("Token 数量 (%d) 超过上下文限制 (%d)", token_count, context_limit),
							vim.log.levels.WARN
						)
						return false
					end
				end)

				-- 工具输出截断回调
				chat:add_callback("on_tool_output", function(c, data)
					local tokens = require("codecompanion.utils.tokens")
					local max_tokens = 10000

					if data.for_llm and tokens.calculate(data.for_llm) > max_tokens then
						local max_chars = max_tokens * 6
						data.for_llm = data.for_llm:sub(1, max_chars) .. "\n\n[输出已截断]"
						data.for_user = data.for_llm
						vim.notify(
							string.format("工具 '%s' 输出已截断 (~%d tokens)", data.tool, max_tokens),
							vim.log.levels.WARN
						)
					end
				end)
			end,
		})
	end,
}
