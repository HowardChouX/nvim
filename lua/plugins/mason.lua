return {
	"mason-org/mason.nvim",
	-- 强制在进入文件缓冲区时加载，确保 LSP 能捕捉到第一个打开的文件
	event = "VeryLazy",
	cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
	dependencies = {
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"neovim/nvim-lspconfig", -- 即使使用原生 API，lspconfig 提供的配置定义仍有很大参考价值
	},
	config = function()
		-- 1. 【关键】环境变量注入
		-- 确保 Neovim 的原生 vim.lsp.enable 能找到 Mason 安装的二进制文件
		local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
		if not string.find(vim.env.PATH, mason_bin) then
			vim.env.PATH = mason_bin .. (vim.loop.os_uname().sysname == "Windows_NT" and ";" or ":") .. vim.env.PATH
		end

		-- 2. Mason 基础设置
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- 3. 定义服务器列表（用于自动化）
		local servers = {
			lua_ls = {
				settings = { Lua = { diagnostics = { globals = { "vim" } } } },
			},
			pyright = {
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							typeCheckingMode = "basic",
						},
					},
				},
			},
			clangd = {
				cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
			},
			-- Racket 不在 Mason 里，需手动通过 raco pkg install racket-langserver 安装
			racket_langserver = {
				filetypes = { "racket", "scheme" },
				cmd = { "racket", "--lib", "racket-langserver" },
			},
		}

		-- 4. 配置 Mason-LSPConfig
		require("mason-lspconfig").setup({
			-- 过滤掉不在 Mason 仓库中的服务器（如 racket）
			ensure_installed = { "lua_ls", "pyright", "clangd" },
			-- 在 0.11+ 中，这个选项会将配置同步给原生 vim.lsp.config
			automatic_installation = true,
		})

		-- 5. 使用原生 API 注册配置并启用
		for name, config in pairs(servers) do
			vim.lsp.config(name, config)
		end

		-- 一键启用所有定义的服务器
		vim.lsp.enable(vim.tbl_keys(servers))

		-- 6. Mason 工具安装 (Formatter/Linter)
		require("mason-tool-installer").setup({
			ensure_installed = { "stylua", "black", "clang-format" },
		})

		-- 7. 优化通知系统：增加连接状态检查
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client then
					vim.notify("" .. client.name .. " ready", vim.log.levels.INFO, {
						title = "LSP",
						timeout = 20000,
					})
				end
			end,
		})
	end,
}
