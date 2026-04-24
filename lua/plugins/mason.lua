-- lua/mason.lua
-- Mason 安装和自动安装 LSP
---@diagnostic disable
return {
	"mason-org/mason.nvim",
	cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
	event = "VeryLazy",
	dependencies = {
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"neovim/nvim-lspconfig",
	},
	config = function()
		-- 【关键】环境变量注入，确保 vim.lsp.enable 能找到 Mason 安装的二进制文件
		local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
		if not string.find(vim.env.PATH, mason_bin) then
			vim.env.PATH = mason_bin .. (vim.loop.os_uname().sysname == "Windows_NT" and ";" or ":") .. vim.env.PATH
		end

		-- Mason UI配置
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- Mason LSP配置 - 使用推荐的自动启用方式
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"pyright",
				"clangd",
				"sqls",
				"jdtls",
			},
			automatic_enable = true,
		})

		-- 使用Neovim 0.11+的vim.lsp.config API配置服务器
		-- 这些配置会被mason-lspconfig自动应用到已安装的服务器

		-- Lua LSP配置
		vim.lsp.config("lua_ls", {
			filetypes = { "lua" },
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})

		-- Python LSP配置
		vim.lsp.config("pyright", {
			filetypes = { "python" },
			handlers = {
				-- 禁用 pyright 的格式化，让 conform 处理
				["textDocument/formatting"] = nil,
				["textDocument/rangeFormatting"] = nil,
			},
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						diagnosticMode = "openFilesOnly",
						useLibraryCodeForTypes = true,
						typeCheckingMode = "basic",
					},
				},
			},
		})

		-- C/C++ LSP配置
		vim.lsp.config("clangd", {
			filetypes = { "c", "cpp", "objc", "objcpp" },
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--header-insertion=iwyu",
				"--completion-style=detailed",
				"--function-arg-placeholders",
				"--fallback-style=llvm",
				"-j=4",
				"--pch-storage=memory",
			},
		})

		-- SQL LSP配置
		vim.lsp.config("sqls", {
			filetypes = { "sql", "mysql", "plsql" },
		})

		-- Java LSP配置 (jdtls)
		-- 动态获取项目根目录下的 .jdtls 数据目录，避免不同项目间冲突
		local java_root_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
		local java_data_dir = vim.fn.stdpath("data") .. "/lsp/jdtls/" .. java_root_dir

		vim.lsp.config("jdtls", {
			filetypes = { "java" },
			-- jdtls 需要通过 cmd 指定启动参数，mason-lspconfig 通常会自动处理，
			-- 但如果需要自定义 data 目录，通常建议配合 nvim-jdtls 插件或使用 on_attach 动态设置。
			-- 在纯 lspconfig + mason 模式下，我们主要通过 settings 和 handlers 优化。
			handlers = {
				-- 禁用 jdtls 的格式化，让 conform.nvim 处理 (google-java-format)
				["textDocument/formatting"] = nil,
				["textDocument/rangeFormatting"] = nil,
			},
			settings = {
				java = {
					configuration = {
						-- 根据检测结果配置运行时。系统当前默认是 Java 21，但很多项目仍依赖 Java 17/11
						-- 这里列出常见运行时，jdtls 会根据项目配置自动选择
						runtimes = {
							{
								name = "JavaSE-21",
								path = "/usr/lib/jvm/java-21-openjdk",
								default = true,
							},
						},
					},
					format = {
						enabled = false, -- 禁用内置格式化，强制使用外部工具 (conform)
					},
					-- 优化签名帮助和文档生成
					signatureHelp = { enabled = true },
					contentProvider = { preferred = "fernflower" }, -- 使用 fernflower 反编译器查看源码
				},
			},
		})

		-- 简化通知系统
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client then
					-- 排除不需要通知的 LSP 服务器
					local excluded_lsp = {
						"render-markdown", -- render-markdown LSP
					}

					-- 检查是否在排除列表中
					local should_notify = true
					for _, excluded in ipairs(excluded_lsp) do
						if client.name == excluded then
							should_notify = false
							break
						end
					end

					if should_notify then
						vim.notify(client.name .. " ready ", vim.log.levels.INFO, {
							title = "LSP",
						})
					end
				end
			end,
		})

		-- Mason工具安装器 - 延迟初始化避免循环依赖
		vim.defer_fn(function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"stylua",
					"black",
					"clang-format",
					"sql-formatter",
					"google-java-format", -- Java 格式化工具
				},
				auto_update = true,
				run_on_start = true,
			})
			-- 自动检查并安装缺失的工具
			require("mason-tool-installer").check_install()
		end, 1000)
	end,
}
