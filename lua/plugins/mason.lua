-- lua/mason.lua
-- Mason 安装和自动安装 LSP
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
			},
			automatic_enable = true
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

        -- Racket LSP配置 - 修正为正确的配置
		vim.lsp.config("racket_langserver", {
			filetypes = { "racket", "scheme" },
			cmd = { "racket", "--lib", "racket-langserver" },  -- 正确的命令 [3]
			settings = {
				racket = {
					completion = {
						enabled = true,
					},
				},
			},
		})
        -- 显式启用 racket_langserver
		vim.lsp.enable("racket_langserver")


		-- 简化通知系统
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client then
					vim.notify(client.name .. " 服务器已启动", vim.log.levels.INFO, {
						title = "LSP",
					})
				end
			end,
		})


		-- Mason工具安装器
		require("mason-tool-installer").setup({
			ensure_installed = {
				"stylua",
				"black",
				"clang-format",
			},
		})
	end,
}
