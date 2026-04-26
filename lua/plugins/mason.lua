-- lua/mason.lua
-- Mason 安装和自动安装 LSP
---@diagnostic disable: undefined-global

return {
	"mason-org/mason.nvim",
	event = "VeryLazy",
	cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
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

		-- JDTLS 配置
		vim.lsp.config("jdtls", {
			filetypes = { "java" },
			cmd = { "jdtls" },
			root_dir = function(fname)
				return vim.fs.root(fname, {
					"mvnw",
					"gradlew",
					".git",
					"pom.xml",
					"build.gradle",
					"build.gradle.kts",
					"build.xml",
					"settings.gradle",
				}) or vim.fn.getcwd()
			end,
			init_options = {
				bundles = {},
			},
			settings = {
				java = {
					home = vim.fn.exepath("java") or "/usr/lib/jvm/default",
				},
			},
		})

		-- LspAttach 事件处理
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if not client then
					return
				end

				-- 调用 LSP 功能增强模块
				if _G.lsp_features then
					_G.lsp_features.on_attach(client, args.bufnr)
				end

				-- 排除不需要通知的 LSP 服务器
				if client.name == "render-markdown" then
					return
				end

				vim.notify(client.name .. " ready", vim.log.levels.INFO, {
					title = "LSP",
				})
			end,
		})

		-- Mason工具安装器
		require("mason-tool-installer").setup({
			ensure_installed = {
				"stylua",
				"black",
				"clang-format",
				"sql-formatter",
				"google-java-format",
			},
			auto_update = true,
			run_on_start = true,
		})
	end,
}
