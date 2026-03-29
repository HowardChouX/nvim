-- CodeCompanion.nvim - AI 编程助手 https://github.com/olimorris/codecompanion.nvim
---@diagnostic disable: undefined-global
return {
	"olimorris/codecompanion.nvim",
    event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"ravitemer/mcphub.nvim",
		"lalitmee/codecompanion-spinners.nvim",
	},
	-- ===== 快捷键配置 =====
	keys = {
		-- Action Palette (<leader> + <tab>)
		{
			"<leader><tab>",
			"<cmd>CodeCompanionActions<cr>",
			mode = { "n", "v" },
			desc = "CodeCompanion Actions",
		},
		-- Toggle Chat (<LocalLeader>a)
		{
			"<leader>a",
			"<cmd>CodeCompanionChat Toggle<cr>",
			mode = { "n", "v" },
			desc = "CodeCompanion Chat Toggle",
		},
		-- Add selection to chat (visual mode)
		{
			"ga",
			"<cmd>CodeCompanionChat Add<cr>",
			mode = "v",
			desc = "CodeCompanion Chat Add Selection",
		},
	},
	opts = {
		-- ===== 触发前缀配置 =====
		triggers = {
			acp_slash_commands = "\\",
			editor_context = "#",
			slash_commands = "/",
			tools = "@",
		},

		-- ===== MCP 原生配置 =====
		-- https://codecompanion.olimorris.dev/configuration/mcp.html
		mcp = {
			servers = {
				-- 文件系统服务器 (限制访问目录)
				["filesystem"] = {
					cmd = { "npx", "-y", "@modelcontextprotocol/server-filesystem" },
					-- Roots: 限制 MCP 服务器可访问的目录
					roots = function()
						return {
							{ name = "config", uri = vim.fn.expand("~/.config") },
							{ name = "home", uri = vim.fn.expand("~") },
							{ name = "cwd", uri = vim.fn.getcwd() },
						}
					end,
					-- 工具默认设置
					tool_defaults = {
						require_approval_before = false, -- 默认不需要批准
					},
					-- 单个工具覆盖配置
					tool_overrides = {
						-- 所有操作都无需批准
						write_file = {
							opts = { require_approval_before = false },
						},
						edit_file = {
							opts = { require_approval_before = false },
						},
						delete_file = {
							opts = { require_approval_before = false },
							enabled = true,
						},
						-- 只读操作无需批准
						read_file = {
							opts = { require_approval_before = false },
						},
						list_directory = {
							opts = { require_approval_before = false },
						},
					},
				},
				-- 顺序思考服务器 (用于复杂推理)
				["sequential-thinking"] = {
					cmd = { "npx", "-y", "@modelcontextprotocol/server-sequential-thinking" },
				},
				-- 内存服务器 (用于持久化记忆)
				["memory"] = {
					cmd = { "npx", "-y", "@modelcontextprotocol/server-memory" },
				},
			},
			-- 默认自动启动的服务器
			opts = {
				default_servers = {"sequential-thinking", "memory"},
				acp_enabled = true, -- 启用 ACP 适配器的 MCP 支持
				timeout = 30e3, -- MCP 服务器响应超时 (毫秒)
			},
		},

		-- ===== 显示配置 =====
		display = {
			action_palette = {
				width = 95,
				height = 10,
				prompt = "Prompt ",
				provider = "telescope",
				opts = {
					show_preset_actions = true,
					show_preset_prompts = true,
					show_preset_rules = true, -- 显示预设规则
					title = "CodeCompanion actions",
				},
			},
			-- 差异显示配置
			diff = {
				enabled = true,
				opts = {
					highlight_whitespace = false, -- 高亮空白字符
				},
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
				show_reasoning = false, -- 显示推理输出
				-- 其他 UI 选项
				intro_message = "欢迎使用 CodeCompanion ✨！按 ? 查看选项",
				separator = "─", -- 消息之间的分隔符
				show_context = true, -- 显示上下文内容
				show_header_separator = true, -- 不显示标题分隔符
				show_settings = false, -- 不在顶部显示 LLM 设置
				show_token_count = true, -- 显示每个响应的 token 数
				show_tools_processing = true, -- 显示工具执行的加载消息
				start_in_insert_mode = false, -- 以普通模式打开聊天缓冲区
				-- 自定义图标
				icons = {
					buffer_sync_all = "󰪴 ",
					buffer_sync_diff = " ",
					chat_context = " ",
					chat_fold = " ",
					tool_pending = "  ",
					tool_in_progress = "  ",
					tool_failure = "  ",
					tool_success = "  ",
				},
				window = {
					layout = "vertical", -- float|vertical|horizontal|tab|buffer
					full_height = true, -- 垂直布局时使用全高
					width = 0.4,
					height = 0.9,
					relative = "editor",
					opts = {
						number = false,
						relativenumber = false,
						signcolumn = "no",
						cursorline = true,
						winbar = "",
						breakindent = true, -- 长段落换行
						linebreak = true,
						wrap = true,
					},
				},
			},
			-- 浮动窗口配置
			floating_window = {
				width = 0.9,
				height = 0.8,
				border = "single",
				relative = "editor",
				opts = {},
			},
			-- 内联助手布局配置
			inline = {
				layout = "vertical", -- vertical|horizontal|buffer
			},
		},

		-- ===== 交互配置 =====
		interactions = {
			-- 后台交互配置 (用于异步任务如生成聊天标题)
			background = {
				adapter = {
					name = "anthropic",
					model = os.getenv("ANTHROPIC_MODEL"),
				},
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
			-- 聊天交互配置 (支持 ACP 和 HTTP 适配器切换)
			chat = {
				adapter = {
					name = "claude_code",
					model = os.getenv("ANTHROPIC_MODEL"),
				},
				-- 角色名称配置
				roles = {
					---The header name for the LLM's messages
					---@type string
					llm = "CodeCompanion",

					---The header name for your messages
					---@type string
					user = "Me",
				},
				-- 工具配置
				tools = {
					-- 工具组配置
					groups = {
						-- Agent 工具组: 全功能代码助手 (推荐)
						["agent"] = {
							description = "Agent - 可运行代码、编辑代码和修改文件",
							tools = {
								"ask_questions",
								"create_file",
								"delete_file",
								"file_search",
								"get_changed_files",
								"get_diagnostics",
								"grep_search",
								"insert_edit_into_file",
								"read_file",
								"run_command",
							},
							opts = {
								collapse_tools = true,
								ignore_system_prompt = true,
								ignore_tool_system_prompt = true,
							},
						},
						-- 文件操作工具组
						["files"] = {
							description = "文件相关操作工具",
							prompt = "我给你 ${tools} 来帮助你执行文件操作",
							tools = {
								"create_file",
								"delete_file",
								"file_search",
								"get_changed_files",
								"grep_search",
								"insert_edit_into_file",
								"read_file",
							},
							opts = {
								collapse_tools = true,
							},
						},
					},
					-- 内置工具配置
					["ask_questions"] = {
						enabled = false, -- 默认隐藏，只能通过 agent 组使用
					},
					["create_file"] = {
						opts = {
							allowed_in_yolo_mode = true, -- 允许在 YOLO 模式下使用
							require_approval_before = false, -- 不需要预先批准
						},
					},
					["delete_file"] = {
						opts = {
							allowed_in_yolo_mode = true, -- 允许在 YOLO 模式下使用
							require_approval_before = false, -- 不需要预先批准
						},
					},
					["file_search"] = {
						opts = {
							max_results = 500, -- 限制返回结果数量
						},
					},
					["get_changed_files"] = {
						opts = {
							max_lines = 1000, -- 限制返回的 diff 行数
						},
					},
					["get_diagnostics"] = {
						opts = {
							-- severity 过滤: "ERROR" | "WARNING" | "INFORMATION" | "HINT"
						},
					},
					["grep_search"] = {
						enabled = function()
							return vim.fn.executable("rg") == 1
						end,
						opts = {
							max_files = 100, -- 限制搜索文件数量
							respect_gitignore = true,
						},
					},
					["insert_edit_into_file"] = {
						opts = {
							allowed_in_yolo_mode = true, -- 允许在 YOLO 模式下使用
							require_approval_before = false, -- 不需要预先批准
							require_confirmation_after = false, -- 不需要事后确认
							file_size_limit_mb = 2, -- 最大文件大小限制
						},
					},
					["read_file"] = {
						opts = {
							allowed_in_yolo_mode = true,
							require_approval_before = false,
						},
					},
					["run_command"] = {
						opts = {
							allowed_in_yolo_mode = true,
							require_approval_before = false,
							require_cmd_approval = false,
						},
					},
					["web_search"] = {
						opts = {
							adapter = "tavily",
							opts = {
								search_depth = "advanced",
								topic = "general",
								chunks_per_source = 3,
								max_results = 5,
							},
						},
					},
					["fetch_webpage"] = {
						opts = {
							adapter = "jina",
						},
					},
					["memory"] = {
						opts = {
							whitelist = {}, -- 可添加白名单路径
						},
					},
					-- 全局工具选项
					opts = {
						auto_submit_errors = true, -- 自动将错误发送给 LLM
						auto_submit_success = true, -- 自动将成功输出发送给 LLM
						folds = {
							enabled = true, -- 折叠工具输出
							failure_words = { "cancelled", "error", "failed", "incorrect", "invalid", "rejected" },
						},
						default_tools = {}, -- 默认加载的工具
						tool_replacement_message = "the ${tool} tool",
					},
				},
				-- 编辑器上下文配置 (使用 #buffer 等)
				editor_context = {
					["buffer"] = {
						opts = {
							contains_code = true,
							default_params = "diff", -- 默认只发送差异部分
						},
					},
					["buffers"] = {
						opts = {
							contains_code = true,
						},
					},
					["diagnostics"] = {
						opts = {
							contains_code = true,
						},
					},
					["diff"] = {
						opts = {
							contains_code = true,
						},
					},
					["messages"] = {
						opts = {
							contains_code = false,
						},
					},
					["quickfix"] = {
						opts = {
							contains_code = true,
						},
					},
					["selection"] = {
						opts = {
							contains_code = true,
						},
					},
					["terminal"] = {
						opts = {
							contains_code = false,
						},
					},
					["viewport"] = {
						opts = {
							contains_code = true,
						},
					},
				},
				-- Slash 命令配置
				slash_commands = {
					["buffer"] = {
						opts = {
							contains_code = true,
							default_params = "diff",
							provider = "telescope",
						},
					},
					["fetch"] = {
						opts = {
							adapter = "jina",
							cache_path = vim.fn.stdpath("data") .. "/codecompanion/urls",
							provider = "telescope",
						},
					},
					["file"] = {
						opts = {
							contains_code = true,
							max_lines = 1000,
							provider = "telescope",
						},
					},
					["help"] = {
						opts = {
							contains_code = false,
							max_lines = 128,
							provider = "telescope",
						},
					},
					["symbols"] = {
						opts = {
							contains_code = true,
							provider = "telescope",
						},
					},
					opts = {
						acp = {
							enabled = true, -- 启用 ACP 命令补全
						},
					},
				},
				-- 快捷键配置
				keymaps = {
					options = {
						modes = { n = "?" },
						description = "选项",
						hide = true,
					},
					completion = {
						modes = { i = "<C-_>" },
						description = "[Chat] 补全菜单",
					},
					send = {
						modes = {
							n = { "<CR>", "<C-s>" },
							i = "<C-s>",
						},
						description = "[Request] 发送响应",
					},
					regenerate = {
						modes = { n = "gr" },
						description = "[Request] 重新生成",
					},
					close = {
						modes = {
							n = "<C-c>",
							i = "<C-c>",
						},
						description = "[Chat] 关闭",
					},
					stop = {
						modes = { n = "q" },
						description = "[Request] 停止",
					},
					clear = {
						modes = { n = "gx" },
						description = "[Chat] 清空",
					},
					codeblock = {
						modes = { n = "gc" },
						description = "[Chat] 插入代码块",
					},
					yank_code = {
						modes = { n = "gy" },
						description = "[Chat] 复制代码",
					},
					buffer_sync_all = {
						modes = { n = "gba" },
						description = "[Chat] 切换缓冲区同步",
					},
					buffer_sync_diff = {
						modes = { n = "gbd" },
						description = "[Chat] 切换缓冲区差异同步",
					},
					next_chat = {
						modes = { n = "}" },
						description = "[Nav] 下一个聊天",
					},
					previous_chat = {
						modes = { n = "{" },
						description = "[Nav] 上一个聊天",
					},
					next_header = {
						modes = { n = "]]" },
						description = "[Nav] 下一个标题",
					},
					previous_header = {
						modes = { n = "[[" },
						description = "[Nav] 上一个标题",
					},
					change_adapter = {
						modes = { n = "ga" },
						description = "[Adapter] 更改适配器和模型",
					},
					fold_code = {
						modes = { n = "gf" },
						description = "[Chat] 折叠代码",
					},
					debug = {
						modes = { n = "gd" },
						description = "[Chat] 查看调试信息",
					},
					system_prompt = {
						modes = { n = "gs" },
						description = "[Chat] 切换系统提示",
					},
					rules = {
						modes = { n = "gM" },
						description = "[Chat] 清除规则",
					},
					clear_approvals = {
						modes = { n = "gtx" },
						description = "[Tools] 清除批准",
					},
					yolo_mode = {
						modes = { n = "gty" },
						description = "[Tools] 切换 YOLO 模式",
					},
					goto_file_under_cursor = {
						modes = { n = "gR" },
						description = "[Chat] 打开光标下的文件",
					},
				},
				-- 聊天选项
				opts = {
					completion_provider = "blink",
					debounce = 150, -- 输入防抖 (毫秒)
					register = "+", -- 复制代码使用的寄存器
					wait_timeout = 2e6, -- 等待用户响应超时 (毫秒)
					yank_jump_delay_ms = 400, -- 复制代码后跳转延迟
					acp_timeout_response = "reject_once", -- ACP 权限请求超时响应
					blank_prompt = "", -- 空提示时的默认提示
				},
			},
			-- 内联交互配置
			inline = {
				adapter = {
					name = "anthropic",
					model = os.getenv("ANTHROPIC_MODEL"),
				},
				keymaps = {
					stop = {
						callback = "keymaps.stop",
						description = "停止请求",
						modes = { n = "q" },
					},
				},
				editor_context = {
					["buffer"] = {
						opts = {
							contains_code = true,
						},
					},
					["chat"] = {
						opts = {
							contains_code = true,
						},
					},
					["clipboard"] = {
						opts = {
							contains_code = true,
						},
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
			-- 共享快捷键配置
			shared = {
				keymaps = {
					view_diff = {
						callback = "keymaps.view_diff",
						description = "查看差异",
						modes = { n = "gv" },
						opts = { nowait = true },
					},
					always_accept = {
						callback = "keymaps.always_accept",
						description = "始终接受此缓冲区的更改",
						modes = { n = "g1" },
						opts = { nowait = true },
					},
					accept_change = {
						callback = "keymaps.accept_change",
						description = "接受更改",
						modes = { n = "g2" },
						opts = { nowait = true, noremap = true },
					},
					reject_change = {
						callback = "keymaps.reject_change",
						description = "拒绝更改",
						modes = { n = "g3" },
						opts = { nowait = true, noremap = true },
					},
					cancel = {
						callback = "keymaps.cancel",
						description = "取消所有待处理的工具调用",
						modes = { n = "g4" },
						opts = { nowait = true },
					},
					next_hunk = {
						callback = "keymaps.next_hunk",
						description = "转到下一个 hunk",
						modes = { n = "}" },
					},
					previous_hunk = {
						callback = "keymaps.previous_hunk",
						description = "转到上一个 hunk",
						modes = { n = "{" },
					},
				},
			},
		},

		-- ===== mcphub 扩展配置 =====
		-- https://github.com/ravitemer/mcphub.nvim
		extensions = {
			mcphub = {
				callback = "mcphub.extensions.codecompanion",
				opts = {
					make_vars = false, -- 禁用变量生成 (因 API 已废弃)
					make_slash_commands = true,
					show_result_in_chat = true,
				},
			},
			-- ===== Spinner 加载动画配置 =====
			-- 在状态栏显示 AI 思考动画
			spinner = {
				style = "lualine", -- 在状态栏显示
				-- 备用配置: 光标跟随模式
				["cursor-relative"] = {
					text = "⠋⠙⠹⠸⠴⠦⠇⠏",
					hl_positions = { 1 },
					interval = 100,
					hl_group = "Title",
					hl_dim_group = "NonText",
				},
			},
		},

		-- ===== 规则配置 =====
		rules = {
			default = {
				description = "通用规则文件集合",
				files = {
					".clinerules",
					".cursorrules",
					".goosehints",
					".rules",
					".windsurfrules",
					"AGENT.md",
					"AGENTS.md",
					{ path = "CLAUDE.md", parser = "claude" },
					{ path = "CLAUDE.local.md", parser = "claude" },
					{ path = "~/.claude/CLAUDE.md", parser = "claude" },
				},
				is_preset = true,
			},
			opts = {
				chat = {
					autoload = "default", -- 自动加载默认规则组
					enabled = true,
					default_params = "diff",
				},
				show_presets = true, -- 显示预设规则文件
			},
		},

		-- ===== 适配器配置 =====
		adapters = {
			http = {
				anthropic = function()
					local base_url = os.getenv("ANTHROPIC_BASE_URL")
					local api_key = os.getenv("ANTHROPIC_API_KEY")
					local model = os.getenv("ANTHROPIC_MODEL")

					if not base_url or not api_key then
						vim.notify(
							"CodeCompanion: 请设置 ANTHROPIC_BASE_URL 和 ANTHROPIC_API_KEY 环境变量",
							vim.log.levels.ERROR
						)
						return nil
					end

					return require("codecompanion.adapters").extend("openai_compatible", {
						env = {
							url = base_url:gsub("/$", ""),
							api_key = api_key,
						},
						schema = {
							model = { default = model },
						},
						opts = {
							allow_insecure = false,
							cache_models_for = 1800, -- 缓存适配器模型 (秒)
							show_presets = false,
							show_model_choices = true,
						},
					})
				end,
			},
			acp = {
				claude_code = function()
					return require("codecompanion.adapters").extend("claude_code", {
						defaults = {
							model = os.getenv("ANTHROPIC_MODEL"),
							mcpServers = "inherit_from_config",
						},
						opts = {
							show_presets = false,
						},
					})
				end,
			},
		},

		-- ===== 通用选项 =====
		opts = {
			log_level = "ERROR", -- TRACE|DEBUG|ERROR|INFO
			language = "English", -- LLM 响应使用的语言
			send_code = true, -- 是否发送代码到 LLM
			submit_delay = 500, -- 自动提交聊天缓冲区前的延迟 (毫秒)
			per_project_config = {
				enabled = true, -- 启用项目级配置
				files = {}, -- 项目配置文件列表
				paths = {}, -- 按路径配置
			},
		},
	},

	-- ===== 回调函数配置 =====
	init = function()
		-- 命令缩写: cc -> CodeCompanion
		vim.cmd([[cab cc CodeCompanion]])

		-- ===== 自定义动作：加载已保存的聊天历史 =====
		local codecompanion = require("codecompanion")
		local config = require("codecompanion.config")

		-- 获取已保存的聊天文件列表
		local function get_saved_chats()
			local chat_dir = vim.fn.stdpath("data") .. "/codecompanion/chats/"
			local files = vim.fn.readdir(chat_dir)
			local chats = {}

			for _, file in ipairs(files) do
				if file:match("%.json$") then
					local filepath = chat_dir .. file
					local content = vim.fn.readfile(filepath)
					local ok, data = pcall(vim.fn.json_decode, table.concat(content, "\n"))
					if ok and data then
						table.insert(chats, {
							name = file:gsub("%.json$", ""),
							description = data.title or data.description or "未命名聊天",
							created = data.created or "",
							filepath = filepath,
						})
					end
				end
			end

			-- 按创建时间排序
			table.sort(chats, function(a, b)
				return (a.created or "") > (b.created or "")
			end)

			return chats
		end

		-- 添加自定义动作到 CodeCompanion
		vim.api.nvim_create_autocmd("User", {
			pattern = "CodeCompanionSetup",
			callback = function()
				local actions = require("codecompanion.actions")

				actions.register({
					name = "Load saved chats ...",
					interaction = " ",
					description = "从磁盘加载已保存的聊天历史",
					picker = {
						prompt = "选择聊天历史",
						provider = config.display.action_palette.provider,
						columns = { "description", "created" },
						items = function()
							local saved_chats = get_saved_chats()
							local items = {}

							if #saved_chats == 0 then
								table.insert(items, {
									name = "no_chats",
									interaction = " ",
									description = "暂无保存的聊天历史",
									created = "",
									callback = function()
										vim.notify("暂无保存的聊天历史，请先创建并保存一个聊天", vim.log.levels.INFO)
									end,
								})
								return items
							end

							for _, chat in ipairs(saved_chats) do
								table.insert(items, {
									name = chat.name,
									interaction = "chat",
									description = chat.description,
									created = chat.created,
									callback = function()
										-- 打开已保存的聊天
										codecompanion.close_last_chat()
										vim.cmd("edit " .. chat.filepath)
										vim.notify("已加载聊天: " .. chat.name, vim.log.levels.INFO)
									end,
								})
							end

							return items
						end,
					},
				})
			end,
		})

		-- Token 限制检查回调
		vim.api.nvim_create_autocmd("User", {
			pattern = "CodeCompanionChatCreated",
			callback = function(args)
				local chat = require("codecompanion").buf_get_chat(args.data.bufnr)

				-- 提交前检查 token 限制
				chat:add_callback("on_before_submit", function(c, _)
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
				chat:add_callback("on_tool_output", function(_, data)
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
