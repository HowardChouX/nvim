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
				"jdtls", -- Java LSP
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

		-- Racket LSP配置 - 暂时禁用，存在兼容性问题
		-- vim.lsp.config("racket_langserver", {
		-- 	filetypes = { "racket", "scheme" },
		-- 	cmd = { "racket", "--lib", "racket-langserver" }, -- 正确的命令 [3]
		-- 	settings = {
		-- 		racket = {
		-- 			completion = {
		-- 				enabled = true,
		-- 			},
		-- 		},
		-- 	},
		-- })
		-- -- 显式启用 racket_langserver
		-- vim.lsp.enable("racket_langserver")

		-- Java LSP配置 (jdtls)
		vim.lsp.config("jdtls", {
			filetypes = { "java" },
			handlers = {
				-- 禁用 jdtls 的格式化，让 conform 处理
				["textDocument/formatting"] = nil,
				["textDocument/rangeFormatting"] = nil,
			},
			settings = {
				java = {
					configuration = {
						runtimes = {
							-- 这里可以根据需要添加 JDK 运行时配置
							-- {
							-- 	name = "JavaSE-17",
							-- 	path = "/path/to/jdk-17",
							-- },
						},
					},
					format = {
						enabled = false, -- 禁用内置格式化，使用 google-java-format
					},
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
