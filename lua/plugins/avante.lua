-- Tell Lua language server that vim is a global variable
---@diagnostic disable: undefined-global

return {
	{
		"yetone/avante.nvim",
		enabled = true,
		event = "VeryLazy",
		keys = {
			{
				"<leader>aa",
				function()
					require("avante.api").ask()
				end,
				desc = "Avante: Ask",
			},
		},
		build = vim.fn.has("win32") ~= 0 and "powershell " .. vim.fn.shellescape(
			"-ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
		) or "make",
		version = false,
		-- Key: Explicitly declare dependency on mcphub.nvim
		dependencies = {
			"ravitemer/mcphub.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-telescope/telescope.nvim",
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = { file_types = { "markdown", "Avante" } },
				ft = { "markdown", "Avante" },
			},
		},
		config = function()
			require("avante_lib").load()
			require("avante").setup({
				-- Main configuration
				mode = "agentic",


				windows = {
					position = "right",
					wrap = true,
					width = 32,
					input = {
						prefix = "> ",
						height = 16,
					},
					sidebar = {
						border = "rounded",
						title = " Avante AI Assistant ",
						title_pos = "center",
						zindex = 50,
					},
					ask = {
						border = "rounded",
						focus_on_apply = "ours",
						width = 32,
						height = 16,
					},
				},
				-- MCP Hub Integration: System prompt
				system_prompt = function()
					-- Use pcall to prevent crashes when mcphub isn't loaded yet
					local status, hub = pcall(require, "mcphub")
					if status then
						local hub_instance = hub.get_hub_instance()
						return hub_instance and hub_instance:get_active_servers_prompt() or ""
					end
					return ""
				end,

				-- MCP Hub Integration: Tools
				custom_tools = function()
					local status, mcp_ext = pcall(require, "mcphub.extensions.avante")
					if status then
						return { mcp_ext.mcp_tool() }
					end
					return {}
				end,
				behaviour = {
					auto_suggestions = false,
					auto_set_highlight_group = true,
					auto_set_keymaps = true,
					auto_apply_diff_after_generation = false,
					show_diff = true,
					confirm_before_apply = true,
					support_paste_from_clipboard = true,
				},

				provider = "CherryIn",
				providers = {
					CherryIn = {
						__inherited_from = "openai",
						endpoint = "https://open.cherryin.ai/v1",
						api_key_name = "CherryIn_API_KEY",
						model = "z-ai/glm-4.6(free)",
					},
					SiliconFlow = {
						__inherited_from = "openai",
						endpoint = "https://api.siliconflow.cn/",
						api_key_name = "SiliconFlow_API_KEY",
						model = "Pro/MiniMaxAI/MiniMax-M2.5",
					},
					ollama = {
						model = "qwen2.5-coder:7b",
						is_env_set = require("avante.providers.ollama").check_endpoint_alive,
					},
				},

				selector = {
					provider = "telescope",
					provider_opts = {},
				},

				web_search_engine = {
					provider = "tavily",
					providers = {
						tavily = { api_key_name = "TAVILY_API_KEY" },
					},
				},

				acp_providers = {

					["claude-code"] = {
						command = "npx",
						args = { "-y", "-g", "@zed-industries/claude-code-acp" },
						env = {
							NODE_NO_WARNINGS = "1",
							ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY"),
							ANTHROPIC_BASE_URL = os.getenv("ANTHROPIC_BASE_URL"),
							ACP_PATH_TO_CLAUDE_CODE_EXECUTABLE = vim.fn.exepath("claude"),
							ACP_PERMISSION_MODE = "bypassPermissions",
						},
					},

					["goose"] = {
						command = "goose",
						args = { "acp" },
					},
				},

				rag_service = {
					enabled = true,
					host_mount = os.getenv("HOME"),
					runner = "docker",
					llm = {
						provider = "ollama",
						endpoint = "http://host.docker.internal:11434",
						model = "deepseek-coder:6.7b-instruct-q4_K_M",
					},
					embed = {
						provider = "ollama",
						endpoint = "http://host.docker.internal:11434",
						model = "bge-m3:latest",
					},
					-- docker_extra_args = "--add-host=host.docker.internal:host-gateway",
					docker_extra_args = "--env http_proxy= --env https_proxy= --env all_proxy= --add-host=host.docker.internal:host-gateway",
				},
			})
		end,
	},
}
