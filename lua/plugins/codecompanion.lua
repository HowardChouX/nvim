-- CodeCompanion.nvim - AI 编程助手 https://github.com/olimorris/codecompanion.nvim
-- =========================== 配置文件说明 ===========================
-- 本文件配置 CodeCompanion.nvim 插件，这是一个功能强大的 AI 编程助手
-- 支持多种 AI 模型和工具，通过 MCP (Model Context Protocol) 协议提供丰富的功能
--
-- 主要功能:
-- 1. 聊天交互: 支持 ACP (Anthropic Code Protocol) 和 HTTP 适配器
-- 2. 代码编辑: 内联代码补全和编辑
-- 3. 文件操作: 通过 MCP 服务器进行安全的文件系统操作
-- 4. 工具集成: Web 搜索、命令行工具、时间工具等
-- 5. 规则系统: 基于文件的项目规则和提示词
--
-- 作者: olimorris
-- 版本: Neovim 插件
-- =========================== 配置开始 ============================

---@diagnostic disable: undefined-global  -- 禁用 undefined-global 诊断警告
return {
	-- =========================== 插件基本信息 ============================
	-- 插件仓库地址和名称
	"olimorris/codecompanion.nvim",

	-- 插件加载时机: VeryLazy 表示在需要时延迟加载
	event = "VeryLazy",
	-- =========================== 依赖插件 ============================
	dependencies = {
		"nvim-lua/plenary.nvim", -- Lua 实用函数库，许多插件的基础依赖
		"nvim-treesitter/nvim-treesitter", -- 语法高亮和解析，为 AI 提供更好的代码理解
		"lalitmee/codecompanion-spinners.nvim", -- 加载动画和状态指示器
	},
	-- =========================== 快捷键配置 ============================
	-- 快捷键定义了用户与插件交互的主要方式
	-- 注意: 根据 CLAUDE.md 中的规则，所有快捷键应统一在 keymap.lua 中管理
	-- 这里的快捷键是插件内置的快捷键定义
	keys = {
		-- =========== Action Palette (动作面板) ===========
		-- 动作面板是插件的核心界面，提供各种预设动作和工具
		-- 快捷键: <leader><tab> (通常是空格+tab)
		{
			"<leader><tab>", -- 快捷键组合
			"<cmd>CodeCompanionActions<cr>", -- 执行的命令
			mode = { "n", "v" }, -- 生效的模式: 普通模式(n)和可视模式(v)
			desc = "CodeCompanion Actions", -- 快捷键描述
		},

		-- =========== Toggle Chat (切换聊天窗口) ===========
		-- 打开/关闭与 AI 的聊天界面
		-- 快捷键: <leader>a (通常是空格+a)
		{
			"<leader>a",
			"<cmd>CodeCompanionChat Toggle<cr>",
			mode = { "n", "v" },
			desc = "CodeCompanion Chat Toggle",
		},

		-- =========== Add selection to chat (添加选中文本到聊天) ===========
		-- 在可视模式下，将选中的文本添加到聊天窗口
		-- 快捷键: ga (仅在可视模式下有效)
		{
			"ga",
			"<cmd>CodeCompanionChat Add<cr>",
			mode = "v", -- 仅在可视模式下生效
			desc = "CodeCompanion Chat Add Selection",
		},
	},
	-- =========================== 插件选项配置 ============================
	-- opts 包含插件的主要配置选项
	opts = {
		-- =========================== 触发前缀配置 ============================
		-- 触发前缀定义了在聊天中输入特殊字符时触发的功能
		-- 这些前缀可以快速访问特定功能，无需打开菜单
		triggers = {
			acp_slash_commands = "\\", -- ACP 斜杠命令前缀 (例如: \help)
			editor_context = "#", -- 编辑器上下文前缀 (例如: #buffer 发送当前缓冲区)
			slash_commands = "/", -- 普通斜杠命令前缀 (例如: /help)
			tools = "@", -- 工具调用前缀 (例如: @filesystem)
		},

		-- =========================== MCP (Model Context Protocol) 配置 ===========================
		-- MCP 是一个协议，允许 AI 模型与外部工具和资源安全地交互
		-- 官方文档: https://codecompanion.olimorris.dev/configuration/mcp.html
		mcp = {
			-- =========== MCP 服务器列表 ===========
			-- 这里配置所有可用的 MCP 服务器
			-- 每个服务器都是一个独立的外部进程，通过标准输入/输出与插件通信
			servers = {
				-- =========== 文件系统服务器 ===========
				-- 提供安全的文件系统操作，限制访问目录以防止安全问题
				["filesystem"] = {
					-- 服务器启动命令
					cmd = { "npx", "-y", "@modelcontextprotocol/server-filesystem" },

					-- =========== 根目录配置 ===========
					-- 限制 MCP 服务器可访问的目录，增强安全性
					-- 只有这些目录下的文件可以被操作
					roots = function()
						return {
							-- 配置文件目录
							{ name = "config", uri = vim.fn.expand("~/.config") },
							-- 用户主目录
							{ name = "home", uri = vim.fn.expand("~") },
							-- 当前工作目录
							{ name = "cwd", uri = vim.fn.getcwd() },
						}
					end,

					-- =========== 工具默认设置 ===========
					-- 定义所有工具的默认行为
					tool_defaults = {
						require_approval_before = false, -- 默认不需要批准，工具可以直接执行
					},

					-- =========== 单个工具覆盖配置 ===========
					-- 可以针对特定工具进行个性化配置
					tool_overrides = {
						-- 写入文件操作
						write_file = {
							opts = { require_approval_before = false }, -- 不需要预先批准
						},
						-- 编辑文件操作
						edit_file = {
							opts = { require_approval_before = false }, -- 不需要预先批准
						},
						-- 删除文件操作
						delete_file = {
							opts = { require_approval_before = false }, -- 不需要预先批准
							enabled = true, -- 启用删除文件功能
						},
						-- 只读操作: 无需批准
						read_file = {
							opts = { require_approval_before = false }, -- 不需要预先批准
						},
						list_directory = {
							opts = { require_approval_before = false }, -- 不需要预先批准
						},
					},
				},
				-- =========== 顺序思考服务器 ===========
				-- 为 AI 提供复杂的推理和思考能力
				-- 适用于需要多步推理的复杂任务
				["sequential-thinking"] = {
					cmd = { "npx", "-y", "@modelcontextprotocol/server-sequential-thinking" },
				},

				-- =========== 内存服务器 ===========
				-- 提供持久化记忆存储功能
				-- AI 可以记住之前的对话和上下文
				["memory"] = {
					cmd = { "npx", "-y", "@modelcontextprotocol/server-memory" },
				},

				-- =========== 时间工具服务器 ===========
				-- 提供时间相关的工具，如获取当前时间、日期计算等
				["time"] = {
					cmd = { "uvx", "mcp-server-time" }, -- 使用 uvx (类似于 npx) 运行
				},

				-- =========== 网络请求服务器 ===========
				-- 提供 HTTP 请求功能，可以获取网页内容
				["fetch"] = {
					cmd = { "uvx", "mcp-server-fetch" },
				},

				-- =========== Tavily 搜索服务器 ===========
				-- 提供 AI 优化的网络搜索功能
				-- Tavily 是一个专门为 AI 优化的搜索引擎
				["tavily"] = {
					cmd = { "npx", "-y", "@mcptools/mcp-tavily" },
					env = {
						TAVILY_API_KEY = "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", -- API 密钥
					},
				},
			},

			-- =========== MCP 全局选项 ===========
			opts = {
				default_servers = {}, -- 默认自动启动的服务器，空表示手动启动
				acp_enabled = true, -- 启用 ACP 适配器的 MCP 支持
				timeout = 30e3, -- MCP 服务器响应超时时间 (30秒)
			},
		},

		-- =========================== 显示配置 ===========================
		-- 控制插件的用户界面和视觉表现
		display = {
			-- =========== 动作面板配置 ===========
			-- 动作面板是用户选择预设动作和工具的主要界面
			action_palette = {
				width = 95, -- 面板宽度 (字符数)
				height = 10, -- 面板高度 (行数)
				prompt = "Prompt ", -- 输入提示
				provider = "telescope", -- 使用 Telescope 作为界面提供者
				opts = {
					show_preset_actions = true, -- 显示预设动作
					show_preset_prompts = true, -- 显示预设提示词
					show_preset_rules = true, -- 显示预设规则
					title = "CodeCompanion actions", -- 面板标题
				},
			},

			-- =========== 差异显示配置 ===========
			-- 控制 AI 修改代码时显示的差异界面
			diff = {
				enabled = true, -- 启用差异显示
				opts = {
					highlight_whitespace = false, -- 不高亮空白字符差异
				},
				word_highlights = {
					additions = true, -- 高亮新增的单词
					deletions = true, -- 高亮删除的单词
				},
			},
			-- =========== 聊天窗口配置 ===========
			-- 聊天窗口是与 AI 交互的主要界面
			chat = {
				auto_scroll = true, -- AI 响应时自动滚动到底部
				fold_context = true, -- 折叠上下文以节省空间
				fold_reasoning = true, -- 流式输出完成后折叠推理内容
				show_reasoning = false, -- 不显示推理过程 (设置为 true 可看到 AI 思考过程)

				-- =========== UI 界面选项 ===========
				intro_message = "欢迎使用 CodeCompanion ✨！按 ? 查看选项", -- 欢迎消息
				separator = "─", -- 消息之间的分隔符
				show_context = true, -- 显示上下文内容
				show_header_separator = true, -- 显示标题分隔符
				show_settings = false, -- 不在顶部显示 LLM 设置
				show_token_count = true, -- 显示每个响应的 token 数量
				show_tools_processing = true, -- 显示工具执行的加载消息
				start_in_insert_mode = false, -- 以普通模式打开聊天缓冲区 (便于使用快捷键)

				-- =========== 自定义图标 ===========
				-- 使用 Nerd Font 图标美化界面
				icons = {
					buffer_sync_all = "󰪴 ", -- 同步所有缓冲区图标
					buffer_sync_diff = " ", -- 同步差异图标
					chat_context = " ", -- 聊天上下文图标
					chat_fold = " ", -- 折叠图标
					tool_pending = "  ", -- 工具等待中图标
					tool_in_progress = "  ", -- 工具执行中图标
					tool_failure = "  ", -- 工具失败图标
					tool_success = "  ", -- 工具成功图标
				},
				-- =========== 窗口布局配置 ===========
				window = {
					layout = "vertical", -- 布局方式: vertical(垂直)|float(浮动)|horizontal(水平)|tab(标签页)|buffer(缓冲区)
					full_height = true, -- 垂直布局时使用全高
					width = 0.4, -- 窗口宽度 (占编辑器宽度的比例)
					height = 0.9, -- 窗口高度 (占编辑器高度的比例)
					relative = "editor", -- 相对位置: editor(编辑器)|win(窗口)|cursor(光标)

					-- =========== 窗口内部选项 ===========
					opts = {
						number = false, -- 不显示行号
						relativenumber = false, -- 不显示相对行号
						signcolumn = "no", -- 不显示标记列
						cursorline = true, -- 高亮当前行
						winbar = "", -- 窗口栏为空
						breakindent = true, -- 长段落自动换行
						linebreak = true, -- 启用换行
						wrap = true, -- 启用文本换行
					},
				},
			},
			-- =========== 浮动窗口配置 ===========
			-- 控制插件中各种浮动窗口的外观
			floating_window = {
				width = 0.9, -- 宽度占编辑器比例
				height = 0.8, -- 高度占编辑器比例
				border = "single", -- 边框样式: single|double|rounded|solid|shadow
				relative = "editor", -- 相对位置
				opts = {}, -- 其他窗口选项
			},

			-- =========== 内联助手布局配置 ===========
			-- 内联助手是在代码编辑器中直接显示 AI 建议的功能
			inline = {
				layout = "vertical", -- 布局方式: vertical(垂直)|horizontal(水平)|buffer(缓冲区)
			},
		},

		-- =========================== 交互配置 ===========================
		-- 配置插件与用户的各种交互方式
		interactions = {
			-- =========== 后台交互配置 ===========
			-- 后台任务使用独立的 AI 适配器，不干扰主聊天界面
			background = {
				-- 适配器配置: 后台任务使用的 AI 模型
				adapter = {
					name = "anthropic", -- 使用 Anthropic HTTP 适配器
					model = os.getenv("ANTHROPIC_MODEL"), -- 从环境变量获取模型
				},

				-- =========== 回调函数配置 ===========
				-- 定义在特定事件发生时执行的动作
				callbacks = {
					["on_ready"] = { -- 插件就绪时触发
						actions = {
							"interactions.background.builtin.chat_make_title", -- 自动生成聊天标题
						},
						enabled = true, -- 启用此回调
					},
				},

				opts = {
					enabled = true, -- 启用后台交互
				},
			},
			-- =========== 聊天交互配置 ===========
			-- 主聊天界面配置，支持 ACP 和 HTTP 适配器切换
			chat = {
				-- =========== 适配器配置 ===========
				-- 聊天界面使用的 AI 适配器
				-- claude_code: 使用 Claude Code ACP 适配器 (推荐)
				-- anthropic: 使用 HTTP 适配器直接调用 Anthropic API
				-- deepseek: 使用 DeepSeek HTTP 适配器
				adapter = {
					name = "claude_code", -- 使用 Claude Code ACP 适配器
					model = os.getenv("ANTHROPIC_MODEL"), -- 从环境变量获取模型
				},

				-- =========== 角色名称配置 ===========
				-- 定义聊天界面中显示的角色名称
				-- llm 角色名称可以是字符串或函数，函数可以动态显示适配器名称
				roles = {
					---The header name for the LLM's messages
					llm = "CodeCompanion",
					---The header name for your messages
					user = "Me", -- 用户消息的显示名称
				},
				-- =========== 工具配置 ===========
				-- 定义 AI 可以使用的各种工具
				-- 工具通过 MCP 服务器提供，实现安全的外部交互
				tools = {
					-- =========== 工具组配置 ===========
					-- 将相关工具分组，便于管理和使用
					groups = {
						-- =========== Agent 工具组 ===========
						-- 全功能代码助手工具组，推荐使用
						-- 包含代码编辑、文件操作、搜索等核心功能
						["agent"] = {
							description = "Agent - 可运行代码、编辑代码和修改文件", -- 工具组描述
							tools = {
								"ask_questions", -- 提问工具
								"create_file", -- 创建文件
								"delete_file", -- 删除文件
								"file_search", -- 文件搜索
								"get_changed_files", -- 获取已更改文件
								"get_diagnostics", -- 获取诊断信息
								"grep_search", -- 文本搜索
								"insert_edit_into_file", -- 插入/编辑文件
								"read_file", -- 读取文件
								"run_command", -- 运行命令
							},
							opts = {
								collapse_tools = true, -- 折叠工具列表
								ignore_system_prompt = true, -- 忽略系统提示
								ignore_tool_system_prompt = true, -- 忽略工具系统提示
							},
						},

						-- =========== 文件操作工具组 ===========
						-- 专注于文件操作的子工具组
						["files"] = {
							description = "文件相关操作工具", -- 工具组描述
							prompt = "我给你 ${tools} 来帮助你执行文件操作", -- 系统提示词
							tools = {
								"create_file", -- 创建文件
								"delete_file", -- 删除文件
								"file_search", -- 文件搜索
								"get_changed_files", -- 获取已更改文件
								"grep_search", -- 文本搜索
								"insert_edit_into_file", -- 插入/编辑文件
								"read_file", -- 读取文件
							},
							opts = {
								collapse_tools = true, -- 折叠工具列表
							},
						},
					},
					-- =========== 内置工具配置 ===========
					-- 配置每个单独工具的行为和权限

					-- ask_questions: 提问工具，默认隐藏，只能通过 agent 组使用
					["ask_questions"] = {
						enabled = false, -- 默认隐藏，防止滥用
					},

					-- create_file: 创建文件工具
					["create_file"] = {
						opts = {
							allowed_in_yolo_mode = true, -- 允许在 YOLO 模式下使用
							require_approval_before = false, -- 不需要预先批准
						},
					},

					-- delete_file: 删除文件工具
					["delete_file"] = {
						opts = {
							allowed_in_yolo_mode = true, -- 允许在 YOLO 模式下使用
							require_approval_before = false, -- 不需要预先批准
						},
					},

					-- file_search: 文件搜索工具
					["file_search"] = {
						opts = {
							max_results = 500, -- 限制返回结果数量，防止过多结果
						},
					},

					-- get_changed_files: 获取已更改文件工具
					["get_changed_files"] = {
						opts = {
							max_lines = 1000, -- 限制返回的 diff 行数
						},
					},

					-- get_diagnostics: 获取诊断信息工具
					["get_diagnostics"] = {
						opts = {
							-- severity 过滤: "ERROR" | "WARNING" | "INFORMATION" | "HINT"
							-- 可以按严重程度过滤诊断信息
						},
					},

					-- grep_search: 文本搜索工具 (依赖 ripgrep)
					["grep_search"] = {
						-- 检查系统是否安装了 ripgrep (rg)
						enabled = function()
							return vim.fn.executable("rg") == 1 -- 返回 1 表示 rg 可用
						end,
						opts = {
							max_files = 100, -- 限制搜索文件数量
							respect_gitignore = true, -- 尊重 .gitignore 规则
						},
					},
					-- insert_edit_into_file: 插入/编辑文件工具
					["insert_edit_into_file"] = {
						opts = {
							allowed_in_yolo_mode = true, -- 允许在 YOLO 模式下使用
							require_approval_before = false, -- 不需要预先批准
							require_confirmation_after = false, -- 不需要事后确认
							file_size_limit_mb = 2, -- 最大文件大小限制 (2MB)
						},
					},

					-- read_file: 读取文件工具
					["read_file"] = {
						opts = {
							allowed_in_yolo_mode = true, -- 允许在 YOLO 模式下使用
							require_approval_before = false, -- 不需要预先批准
						},
					},

					-- run_command: 运行命令工具
					["run_command"] = {
						opts = {
							allowed_in_yolo_mode = true, -- 允许在 YOLO 模式下使用
							require_approval_before = false, -- 不需要预先批准
							require_cmd_approval = false, -- 不需要命令批准
						},
					},

					-- web_search: 网络搜索工具 (使用 Tavily)
					["web_search"] = {
						opts = {
							adapter = "tavily", -- 使用 Tavily 适配器
							opts = {
								search_depth = "advanced", -- 搜索深度: basic|advanced
								topic = "general", -- 搜索主题: general|news|finance
								chunks_per_source = 3, -- 每个来源的文本块数
								max_results = 5, -- 最大结果数
							},
						},
					},

					-- fetch_webpage: 获取网页内容工具 (使用 Jina)
					["fetch_webpage"] = {
						opts = {
							adapter = "jina", -- 使用 Jina 适配器
						},
					},

					-- memory: 记忆工具
					["memory"] = {
						opts = {
							whitelist = {}, -- 可添加白名单路径，控制记忆存储位置
						},
					},
					-- =========== 全局工具选项 ===========
					opts = {
						auto_submit_errors = true, -- 自动将错误信息发送给 LLM
						auto_submit_success = true, -- 自动将成功输出发送给 LLM
						folds = {
							enabled = true, -- 启用工具输出折叠
							-- 包含这些关键词的失败消息会被折叠
							failure_words = { "cancelled", "error", "failed", "incorrect", "invalid", "rejected" },
						},
						default_tools = {}, -- 默认加载的工具列表，空表示不自动加载
						tool_replacement_message = "the ${tool} tool", -- 工具替换消息模板
					},
				},
				-- =========== 编辑器上下文配置 ===========
				-- 配置 # 前缀命令，用于快速发送编辑器内容给 AI
				-- 例如: #buffer 发送当前缓冲区，#selection 发送选中文本
				editor_context = {
					-- #buffer: 发送当前缓冲区内容
					["buffer"] = {
						opts = {
							contains_code = true, -- 内容包含代码
							default_params = "diff", -- 默认只发送差异部分
						},
					},

					-- #buffers: 发送所有缓冲区内容
					["buffers"] = {
						opts = {
							contains_code = true, -- 内容包含代码
						},
					},

					-- #diagnostics: 发送诊断信息
					["diagnostics"] = {
						opts = {
							contains_code = true, -- 内容包含代码
						},
					},

					-- #diff: 发送差异内容
					["diff"] = {
						opts = {
							contains_code = true, -- 内容包含代码
						},
					},

					-- #messages: 发送消息
					["messages"] = {
						opts = {
							contains_code = false, -- 内容不包含代码
						},
					},

					-- #quickfix: 发送 quickfix 列表
					["quickfix"] = {
						opts = {
							contains_code = true, -- 内容包含代码
						},
					},

					-- #selection: 发送选中文本
					["selection"] = {
						opts = {
							contains_code = true, -- 内容包含代码
						},
					},

					-- #terminal: 发送终端输出
					["terminal"] = {
						opts = {
							contains_code = false, -- 内容不包含代码
						},
					},

					-- #viewport: 发送当前视口内容
					["viewport"] = {
						opts = {
							contains_code = true, -- 内容包含代码
						},
					},
				},
				-- =========== Slash 命令配置 ===========
				-- 配置 / 前缀命令，提供更丰富的功能选择
				slash_commands = {
					-- /buffer: 发送缓冲区内容 (通过 Telescope 选择)
					["buffer"] = {
						opts = {
							contains_code = true, -- 内容包含代码
							default_params = "diff", -- 默认只发送差异部分
							provider = "telescope", -- 使用 Telescope 提供界面
						},
					},

					-- /fetch: 获取网页内容
					["fetch"] = {
						opts = {
							adapter = "jina", -- 使用 Jina 适配器
							cache_path = vim.fn.stdpath("data") .. "/codecompanion/urls", -- 缓存路径
							provider = "telescope", -- 使用 Telescope 提供界面
						},
					},

					-- /file: 发送文件内容
					["file"] = {
						opts = {
							contains_code = true, -- 内容包含代码
							max_lines = 1000, -- 最大行数限制
							provider = "telescope", -- 使用 Telescope 提供界面
						},
					},

					-- /help: 发送帮助信息
					["help"] = {
						opts = {
							contains_code = false, -- 内容不包含代码
							max_lines = 128, -- 最大行数限制
							provider = "telescope", -- 使用 Telescope 提供界面
						},
					},

					-- /symbols: 发送符号列表
					["symbols"] = {
						opts = {
							contains_code = true, -- 内容包含代码
							provider = "telescope", -- 使用 Telescope 提供界面
						},
					},

					opts = {
						acp = {
							enabled = true, -- 启用 ACP 命令补全
						},
					},
				},
				-- =========== 快捷键配置 ===========
				-- 定义聊天界面中的各种快捷键
				keymaps = {
					-- options: 显示所有可用选项
					options = {
						modes = { n = "?" }, -- 在普通模式下按 ? 显示选项
						description = "选项", -- 描述
						hide = true, -- 默认隐藏
					},

					-- completion: 打开补全菜单
					completion = {
						modes = { i = "<C-_>" }, -- 在插入模式下按 Ctrl+/ 打开补全
						description = "[Chat] 补全菜单",
					},

					-- send: 发送消息
					send = {
						modes = {
							n = { "<CR>", "<C-s>" }, -- 普通模式下按 Enter 或 Ctrl+S 发送
							i = "<C-s>", -- 插入模式下按 Ctrl+S 发送
						},
						description = "[Request] 发送响应",
					},

					-- regenerate: 重新生成响应
					regenerate = {
						modes = { n = "gr" }, -- 普通模式下按 gr 重新生成
						description = "[Request] 重新生成",
					},

					-- close: 关闭聊天窗口
					close = {
						modes = {
							n = "<C-c>", -- 普通模式下按 Ctrl+C 关闭
							i = "<C-c>", -- 插入模式下按 Ctrl+C 关闭
						},
						description = "[Chat] 关闭",
					},

					-- stop: 停止响应生成
					stop = {
						modes = { n = "q" }, -- 普通模式下按 q 停止
						description = "[Request] 停止",
					},

					-- clear: 清空聊天内容
					clear = {
						modes = { n = "gx" }, -- 普通模式下按 gx 清空
						description = "[Chat] 清空",
					},

					-- codeblock: 插入代码块
					codeblock = {
						modes = { n = "gc" }, -- 普通模式下按 gc 插入代码块
						description = "[Chat] 插入代码块",
					},

					-- yank_code: 复制代码
					yank_code = {
						modes = { n = "gy" }, -- 普通模式下按 gy 复制代码
						description = "[Chat] 复制代码",
					},

					-- buffer_sync_all: 切换缓冲区同步
					buffer_sync_all = {
						modes = { n = "gba" }, -- 普通模式下按 gba 切换同步
						description = "[Chat] 切换缓冲区同步",
					},

					-- buffer_sync_diff: 切换缓冲区差异同步
					buffer_sync_diff = {
						modes = { n = "gbd" }, -- 普通模式下按 gbd 切换差异同步
						description = "[Chat] 切换缓冲区差异同步",
					},

					-- next_chat: 切换到下一个聊天
					next_chat = {
						modes = { n = "}" }, -- 普通模式下按 } 下一个聊天
						description = "[Nav] 下一个聊天",
					},

					-- previous_chat: 切换到上一个聊天
					previous_chat = {
						modes = { n = "{" }, -- 普通模式下按 { 上一个聊天
						description = "[Nav] 上一个聊天",
					},

					-- next_header: 切换到下一个标题
					next_header = {
						modes = { n = "]]" }, -- 普通模式下按 ]] 下一个标题
						description = "[Nav] 下一个标题",
					},

					-- previous_header: 切换到上一个标题
					previous_header = {
						modes = { n = "[[" }, -- 普通模式下按 [[ 上一个标题
						description = "[Nav] 上一个标题",
					},

					-- change_adapter: 更改适配器和模型
					change_adapter = {
						modes = { n = "ga" }, -- 普通模式下按 ga 更改适配器
						description = "[Adapter] 更改适配器和模型",
					},

					-- fold_code: 折叠代码
					fold_code = {
						modes = { n = "gf" }, -- 普通模式下按 gf 折叠代码
						description = "[Chat] 折叠代码",
					},

					-- debug: 查看调试信息
					debug = {
						modes = { n = "gd" }, -- 普通模式下按 gd 查看调试信息
						description = "[Chat] 查看调试信息",
					},

					-- system_prompt: 切换系统提示
					system_prompt = {
						modes = { n = "gs" }, -- 普通模式下按 gs 切换系统提示
						description = "[Chat] 切换系统提示",
					},

					-- rules: 清除规则
					rules = {
						modes = { n = "gM" }, -- 普通模式下按 gM 清除规则
						description = "[Chat] 清除规则",
					},

					-- clear_approvals: 清除批准
					clear_approvals = {
						modes = { n = "gtx" }, -- 普通模式下按 gtx 清除批准
						description = "[Tools] 清除批准",
					},

					-- yolo_mode: 切换 YOLO 模式
					yolo_mode = {
						modes = { n = "gty" }, -- 普通模式下按 gty 切换 YOLO 模式
						description = "[Tools] 切换 YOLO 模式",
					},

					-- goto_file_under_cursor: 打开光标下的文件
					goto_file_under_cursor = {
						modes = { n = "gR" }, -- 普通模式下按 gR 打开光标下的文件
						description = "[Chat] 打开光标下的文件",
					},
				},
				-- =========== 聊天选项 ===========
				opts = {
					completion_provider = "blink", -- 使用 blink.nvim 作为补全提供者
					debounce = 150, -- 输入防抖延迟 (毫秒)
					register = "+", -- 复制代码使用的寄存器
					wait_timeout = 2e6, -- 等待用户响应超时 (毫秒)
					yank_jump_delay_ms = 400, -- 复制代码后跳转延迟 (毫秒)
					acp_timeout_response = "reject_once", -- ACP 权限请求超时响应策略
					blank_prompt = "", -- 空提示时的默认提示
				},
			},
			-- =========== 内联交互配置 ===========
			-- 内联助手是在代码编辑器中直接显示 AI 建议的功能
			-- 用户可以在不离开编辑窗口的情况下获取 AI 帮助
			inline = {
				-- =========== 适配器配置 ===========
				-- 内联助手的 AI 模型适配器
				adapter = {
					name = "anthropic", -- 使用 Anthropic HTTP 适配器
					model = os.getenv("ANTHROPIC_MODEL"), -- 从环境变量获取模型
				},
				-- =========== 快捷键配置 ===========
				-- 内联助手的专用快捷键
				keymaps = {
					-- stop: 停止 AI 请求生成
					stop = {
						callback = "keymaps.stop", -- 回调函数名称
						description = "停止请求", -- 快捷键描述
						modes = { n = "q" }, -- 在普通模式下按 q 停止
					},
				},
				-- =========== 编辑器上下文配置 ===========
				-- 内联助手的上下文发送配置
				editor_context = {
					-- #buffer: 发送当前缓冲区内容给内联助手
					["buffer"] = {
						opts = {
							contains_code = true, -- 内容包含代码
						},
					},
					-- #chat: 发送聊天历史给内联助手
					["chat"] = {
						opts = {
							contains_code = true, -- 内容包含代码
						},
					},
					-- #clipboard: 发送剪贴板内容给内联助手
					["clipboard"] = {
						opts = {
							contains_code = true, -- 内容包含代码
						},
					},
				},
			},
			-- =========== 命令行交互配置 ===========
			-- 命令行模式下的 AI 助手功能
			-- 用户可以通过 :CodeCompanion 命令来使用 AI
			cmd = {
				-- =========== 适配器配置 ===========
				-- 命令行模式下使用的 AI 适配器
				adapter = {
					name = "anthropic", -- 使用 Anthropic HTTP 适配器
					model = os.getenv("ANTHROPIC_MODEL"), -- 从环境变量获取模型
				},
			},
		},

		-- ===== 扩展配置 =====
		-- 插件扩展功能配置
		extensions = {
			-- ===== Spinner 加载动画配置 =====
			-- 在状态栏显示 AI 思考动画，提供视觉反馈
			-- 当 AI 处理请求时，显示旋转动画表示正在工作
			spinner = {
				style = "lualine", -- 在状态栏显示动画，集成到 lualine 状态栏中
				-- ===== 光标跟随模式备用配置 =====
				-- 备用动画配置：在光标位置显示动画
				["cursor-relative"] = {
					text = "⠋⠙⠹⠸⠴⠦⠇⠏", -- 旋转动画字符序列
					hl_positions = { 1 }, -- 高亮位置，第一个字符高亮
					interval = 100, -- 动画帧间隔 (毫秒)
					hl_group = "Title", -- 高亮组，使用 Title 高亮样式
					hl_dim_group = "NonText", -- 暗淡高亮组，使用 NonText 样式
				},
			},
		},

		-- ===== 规则配置 =====
		-- 规则系统允许定义项目特定的行为准则和提示词
		-- AI 会自动读取这些规则文件，遵循项目约定
		rules = {
			-- ===== 默认规则组 =====
			default = {
				description = "通用规则文件集合",
				files = {
					".clinerules", -- Cursor IDE 规则文件
					".cursorrules", -- Cursor 编辑器规则文件
					".goosehints", -- Goose IDE 提示文件
					".rules", -- 通用规则文件
					".windsurfrules", -- Windsurf IDE 规则文件
					"AGENT.md", -- 代理人规则文档
					"AGENTS.md", -- 多代理人规则文档
					{ path = "CLAUDE.md", parser = "claude" }, -- Claude 项目说明文档
					{ path = "CLAUDE.local.md", parser = "claude" }, -- 本地 Claude 项目说明
					{ path = "~/.claude/CLAUDE.md", parser = "claude" }, -- 全局 Claude 配置
				},
				is_preset = true, -- 这是一个预设规则组
			},
			-- ===== 规则选项配置 =====
			opts = {
				chat = {
					autoload = "default", -- 自动加载默认规则组
					enabled = true, -- 启用规则系统
					default_params = "diff", -- 默认只发送差异部分
				},
				show_presets = true, -- 在界面中显示预设规则文件
			},
		},

		-- ===== 适配器配置 =====
		-- 适配器配置定义不同 AI 模型提供商的支持
		-- 插件支持 HTTP API 和 ACP (Anthropic Code Protocol) 两种连接方式
		adapters = {
			-- ===== HTTP 适配器配置 =====
			-- 通过 HTTP API 连接到 AI 模型提供商
			http = {
				-- ===== HTTP 全局选项 =====
				opts = {
					allow_insecure = false, -- 不允许不安全的 HTTP 连接
					cache_models_for = 1800, -- 缓存适配器模型信息 (秒，30分钟)
					show_presets = false, -- 不显示预设模型
					show_model_choices = true, -- 显示模型选择界面
				},
				-- ===== Anthropic 适配器配置 =====
				-- 配置连接到 Anthropic Claude API
				anthropic = function()
					local base_url = os.getenv("ANTHROPIC_BASE_URL")
					local api_key = os.getenv("ANTHROPIC_API_KEY")
					local model = os.getenv("ANTHROPIC_MODEL")

					-- ===== 环境变量检查 =====
					if not base_url or not api_key then
						vim.notify(
							"CodeCompanion: 请设置 ANTHROPIC_BASE_URL 和 ANTHROPIC_API_KEY 环境变量",
							vim.log.levels.ERROR
						)
						return nil
					end
					-- ===== 适配器扩展 =====
					-- 基于 OpenAI 兼容 API 配置 Anthropic 适配器
					return require("codecompanion.adapters").extend("openai_compatible", {
						env = {
							url = base_url:gsub("/$", ""), -- 清理 URL 结尾的斜杠
							api_key = api_key, -- API 密钥
						},
						schema = {
							model = { default = model }, -- 默认模型配置
						},
					})
				end,
				-- ===== DeepSeek 适配器配置 =====
				-- 配置连接到 DeepSeek API
				deepseek = function()
					local base_url = "https://api.deepseek.com"
					local api_key = os.getenv("DeepSeek_API_KEY")
					local model = "deepseek-chat"
					-- ===== 适配器扩展 =====
					-- 基于 OpenAI 兼容 API 配置 DeepSeek 适配器
					return require("codecompanion.adapters").extend("deepseek", {
						env = {
							url = base_url,
							api_key = api_key, -- API 密钥
						},
						schema = {
							model = { default = model }, -- 默认模型配置
						},
					})
				end,

				-- ===== Qwen2API 适配器配置 =====
				-- 配置连接到 Qwen2API 本地服务
				qwen = function()
					local base_url = "http://localhost:3000"
					local api_key = "sk-admin123"
					local model = "qwen-max-latest"

					-- ===== 环境变量检查 =====
					if not api_key then
						vim.notify("CodeCompanion: 请设置 QWEN2API_API_KEY 环境变量", vim.log.levels.WARN)
						return nil
					end
					-- ===== 适配器扩展 =====
					-- 基于 OpenAI 兼容 API 配置 Qwen2API 适配器
					return require("codecompanion.adapters").extend("openai_compatible", {
						env = {
							url = base_url,
							api_key = api_key, -- API 密钥
						},
						schema = {
							model = { default = model },
						},
					})
				end,
			},

			-- ===== ACP (Anthropic Code Protocol) 适配器配置 =====
			-- ACP 是 Claude Code 和 IDE 插件之间的通信协议
			-- 提供更高效的本地集成和权限管理
			acp = {
				-- ===== ACP 全局选项 =====
				opts = {
					allow_insecure = false, -- 不允许不安全的连接
					cache_models_for = 1800, -- 缓存适配器模型信息 (秒，30分钟)
					show_presets = false, -- 不显示预设模型
					show_model_choices = true, -- 显示模型选择界面
				},
				-- ===== Claude Code 适配器配置 =====
				-- 配置连接到 Claude Code (桌面应用)
				claude_code = function()
					-- ===== 适配器扩展 =====
					-- 基于 Claude Code ACP 适配器扩展配置
					return require("codecompanion.adapters").extend("claude_code", {
						defaults = {
							model = os.getenv("ANTHROPIC_MODEL"), -- 从环境变量获取模型
							mcpServers = "inherit_from_config", -- 继承配置文件中的 MCP 服务器设置
						},
					})
				end,
			},
		},

		-- ===== 通用选项 =====
		-- 插件全局配置选项
		opts = {
			log_level = "ERROR", -- 日志级别: TRACE|DEBUG|ERROR|INFO
			language = "Chinese", -- LLM 响应使用的语言
			send_code = true, -- 是否发送代码到 LLM
			submit_delay = 500, -- 自动提交聊天缓冲区前的延迟 (毫秒)
			-- ===== 项目级配置 =====
			-- 允许每个项目有自己的 CodeCompanion 配置
			per_project_config = {
				enabled = true, -- 启用项目级配置
				files = {}, -- 项目配置文件列表
				paths = {}, -- 按路径配置
			},
		},
	},
}
