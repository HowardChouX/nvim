-- MCP Hub - MCP 服务器管理中心
-- https://github.com/ravitemer/mcphub.nvim
-- 负责管理所有 MCP 服务器的生命周期、权限控制和工具协调
--
-- 🚀 开箱即用: git clone 后无需额外配置即可使用
-- 📦 所有 MCP 服务器配置已内置，无需手动创建 servers.json
---@diagnostic disable: undefined-global

return {
	"ravitemer/mcphub.nvim",
	enabled = true,
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	build = "npm install -g mcp-hub@latest",
	config = function()
		-- ===== 自动生成 servers.json (开箱即用) =====
		local servers_config = vim.fn.expand("~/.config/mcphub/servers.json")
		local servers_dir = vim.fn.fnamemodify(servers_config, ":h")

		-- 确保目录存在
		if vim.fn.isdirectory(servers_dir) == 0 then
			vim.fn.mkdir(servers_dir, "p")
		end

		-- 默认服务器配置 (无需 API Key，开箱即用)
		local default_servers = {
			nativeMCPServers = {
				neovim = {
					autoApprove = {
						"execute_lua",
						"execute_command",
						"read_file",
						"read_multiple_files",
						"find_files",
						"list_directory",
					},
				},
				mcphub = {
					autoApprove = {
						"get_current_servers",
						"toggle_mcp_server",
					},
				},
			},
			mcpServers = {
				-- 文件系统服务器
				filesystem = {
					command = "npx",
					args = { "-y", "@modelcontextprotocol/server-filesystem" },
					disabled = false,
					autoApprove = {
						"read_file",
						"read_multiple_files",
						"list_directory",
						"list_files",
						"search_files",
						"get_file_info",
						"list_allowed_directories",
					},
					env = {
						MCP_FILESYSTEM_ROOTS = "~/.config:~:.",
					},
				},
				-- 顺序思考服务器 (复杂推理)
				["sequential-thinking"] = {
					command = "npx",
					args = { "-y", "@modelcontextprotocol/server-sequential-thinking" },
					disabled = false,
				},
				-- 记忆服务器 (持久化上下文)
				memory = {
					command = "npx",
					args = { "-y", "@modelcontextprotocol/server-memory" },
					disabled = false,
				},
				-- Tavily 搜索 (需要 API Key)
				["tavily-search"] = {
					command = "npx",
					args = { "-y", "@anthropic-ai/mcp-server-tavily" },
					disabled = false,
					autoApprove = {
						"search",
						"web_search",
						"tavily_search",
					},
					env = {
						TAVILY_API_KEY = os.getenv("TAVILY_API_KEY"),
					},
				},
			},
		}

		-- 如果 servers.json 不存在，自动创建
		if vim.fn.filereadable(servers_config) == 0 then
			vim.fn.writefile({ vim.json.encode(default_servers) }, servers_config)
			vim.notify("✓ 已创建默认 MCP 服务器配置: " .. servers_config, vim.log.levels.INFO, { title = "MCP Hub" })
		end

		require("mcphub").setup({
			-- ===== 核心配置 =====
			config = servers_config,
			port = 40001,
			shutdown_delay = 5 * 60 * 1000, -- 5分钟后自动关闭不活动的服务器
			mcp_request_timeout = 60000, -- 单个工具执行超时时间 (60秒)

			-- ===== 全局环境变量 =====
			global_env = function(context)
				local env = {
					"DBUS_SESSION_BUS_ADDRESS",
					"XDG_SESSION_TYPE",
					"PATH",
					"HOME",
				}
				if context.is_workspace_mode then
					env.WORKSPACE_ROOT = context.workspace_root
					env.WORKSPACE_PORT = tostring(context.port)
				end
				return env
			end,

			-- ===== 工作区配置 =====
			workspace = {
				enabled = true,
				look_for = { ".mcphub/servers.json" },
				reload_on_dir_changed = true,
				port_range = { min = 40000, max = 41000 },
			},

			-- ===== 智能自动授权 =====
			auto_approve = function(params)
				-- 1. 服务器级别配置优先
				if params.is_auto_approved_in_server then
					return true
				end

				-- 2. 只读/安全工具自动批准
				local safe_tools = {
					-- 文件系统只读
					"read_file", "read_multiple_files", "find_files", "list_directory",
					"list_files", "search_files", "get_file_info", "list_allowed_directories",
					-- 网络只读
					"fetch", "read_url", "navigate", "screenshot", "get_content",
					-- Tavily 搜索
					"tavily_search", "tavily_extract", "tavily_crawl",
					-- 数据库只读
					"read_query", "describe_table", "list_tables",
					-- Git 只读
					"git_log", "git_status", "git_diff", "git_show",
					-- 其他安全工具
					"get_current_time",
					-- Neovim 内置
					"execute_lua", "execute_command",
					-- MCP Hub 管理
					"get_current_servers", "toggle_mcp_server",
				}
				if params.tool_name and vim.tbl_contains(safe_tools, params.tool_name) then
					return true
				end

				-- 3. 危险工具需要确认
				local dangerous_tools = {
					-- 文件写入/删除
					"write_file", "edit_file", "delete_file", "delete_items",
					"move_file", "move_item", "copy_file", "create_directory",
					-- Git 写入操作
					"git_commit", "git_push", "git_reset", "git_checkout",
					-- 数据库写入
					"sqlite_execute", "sqlite_insert", "sqlite_update", "sqlite_delete",
					-- 命令执行
					"run_command", "execute", "shell",
				}
				if params.tool_name and vim.tbl_contains(dangerous_tools, params.tool_name) then
					vim.notify("⚠️ 危险操作需要确认: " .. params.tool_name, vim.log.levels.WARN, { title = "MCP Hub" })
					return false
				end

				-- 4. 默认需要确认
				return false
			end,

			auto_toggle_mcp_servers = true,


			-- ===== 内置工具配置 =====
			builtin_tools = {
				edit_file = {
					parser = {
						track_issues = true,
						extract_inline_content = true,
					},
					locator = {
						fuzzy_threshold = 0.8,
						enable_fuzzy_matching = true,
					},
					ui = {
						go_to_origin_on_complete = true,
						keybindings = {
							accept = "<C-y>",
							reject = "<C-n>",
							next = "n",
							prev = "p",
							accept_all = "ga",
							reject_all = "gr",
						},
					},
				},
			},

			-- ===== UI 配置 =====
			ui = {
				window = {
					width = 0.8,
					height = 0.8,
					align = "center",
					relative = "editor",
					zindex = 50,
					border = "rounded",
				},
				wo = { winhl = "Normal:MCPHubNormal,FloatBorder:MCPHubBorder" },
			},

			-- ===== 回调函数 =====
			on_ready = function(_)
				vim.notify("✓ MCP Hub 已就绪", vim.log.levels.INFO, { title = "MCP Hub" })
			end,
			on_error = function(err)
				vim.notify("✗ MCP Hub 错误: " .. err, vim.log.levels.ERROR, { title = "MCP Hub" })
			end,

			-- ===== 日志配置 =====
			log = {
				level = vim.log.levels.WARN,
				to_file = true,
				file_path = nil,
				prefix = "MCPHub",
			},
		})
	end,
}
