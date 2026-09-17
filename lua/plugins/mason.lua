---@diagnostic disable: undefined-global

local function java_home()
	local configured = vim.env.JAVA_HOME
	if configured and vim.fn.executable(vim.fs.joinpath(configured, "bin", "java")) == 1 then
		return configured
	end

	for _, candidate in ipairs({
		"/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home",
		"/usr/local/opt/openjdk/libexec/openjdk.jdk/Contents/Home",
	}) do
		if vim.fn.executable(vim.fs.joinpath(candidate, "bin", "java")) == 1 then
			return candidate
		end
	end

	if vim.fn.has("mac") == 1 and vim.fn.executable("/usr/libexec/java_home") == 1 then
		local result = vim.system({ "/usr/libexec/java_home" }, { text = true }):wait()
		if result.code == 0 then
			local detected = vim.trim(result.stdout or "")
			if detected ~= "" then
				return detected
			end
		end
	end
end

return {
	"mason-org/mason.nvim",
	event = { "BufReadPre", "BufNewFile" },
	cmd = {
		"Mason",
		"MasonInstall",
		"MasonUpdate",
		"MasonUninstall",
		"MasonUninstallAll",
		"MasonLog",
		"MasonToolsInstall",
		"MasonToolsInstallSync",
		"MasonToolsUpdate",
		"MasonToolsUpdateSync",
		"MasonToolsClean",
	},
	dependencies = {
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"neovim/nvim-lspconfig",
	},
	init = function()
		local mason_bin = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin")
		if not vim.env.PATH:find(mason_bin, 1, true) then
			local separator = vim.uv.os_uname().sysname == "Windows_NT" and ";" or ":"
			vim.env.PATH = mason_bin .. separator .. vim.env.PATH
		end
	end,
	config = function()
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- 把 blink.cmp 的能力集交给所有 LSP，确保 snippet / labelDetails / resolve 等补全正常。
		local blink_ok, blink = pcall(require, "blink.cmp")
		if blink_ok then
			vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities() })
		end

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = { diagnostics = { globals = { "vim" } } },
			},
		})

		vim.lsp.config("pyright", {
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

		-- 前端：vtsls 负责 JS/TS/React，并把 vue 并入 filetypes 以支持 Vue SFC 里的 TS。
		-- vue_ls 在 hybrid 模式下需要 vtsls + @vue/typescript-plugin 协同工作。
		local vue_plugin_path = vim.fs.joinpath(
			vim.fn.stdpath("data"),
			"mason",
			"packages",
			"vue-language-server",
			"node_modules",
			"@vue",
			"language-server"
		)
		local vtsls = {
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
		}
		if vim.uv.fs_stat(vue_plugin_path) then
			vtsls.settings = {
				vtsls = {
					tsserver = {
						globalPlugins = {
							{
								name = "@vue/typescript-plugin",
								location = vue_plugin_path,
								languages = { "vue" },
								configNamespace = "typescript",
							},
						},
					},
				},
			}
		end
		vim.lsp.config("vtsls", vtsls)

		local servers = {
			"lua_ls",
			"pyright",
			"clangd",
			"vtsls",
			"vue_ls",
			"html",
			"cssls",
			"emmet_language_server",
		}
		local detected_java_home = java_home()
		if detected_java_home then
			vim.env.JAVA_HOME = detected_java_home
			local java_bin = vim.fs.joinpath(detected_java_home, "bin")
			if not vim.env.PATH:find(java_bin, 1, true) then
				vim.env.PATH = java_bin .. ":" .. vim.env.PATH
			end
			vim.lsp.config("jdtls", {
				cmd = { "jdtls" },
				root_dir = function(bufnr, on_dir)
					local filename = vim.api.nvim_buf_get_name(bufnr)
					local root = vim.fs.root(filename, {
						"mvnw",
						"gradlew",
						"pom.xml",
						"build.gradle",
						"build.gradle.kts",
						"settings.gradle",
						".git",
					})
					on_dir(root or vim.fs.dirname(filename))
				end,
				settings = { java = { home = detected_java_home } },
			})
			table.insert(servers, "jdtls")
		else
			vim.schedule(function()
				vim.notify_once("未检测到 JDK，已跳过 jdtls；请设置 JAVA_HOME", vim.log.levels.WARN)
			end)
		end

		-- 配置完成后再启用，确保首个 FileType 使用最终配置。
		require("mason-lspconfig").setup({
			ensure_installed = servers,
			automatic_enable = servers,
		})

		local attach_group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true })
		vim.api.nvim_create_autocmd("LspAttach", {
			group = attach_group,
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				local bufnr = args.buf
				if not client or not vim.api.nvim_buf_is_valid(bufnr) then
					return
				end

				local highlight_filetypes = {
					lua = true,
					python = true,
					c = true,
					cpp = true,
					java = true,
					javascript = true,
					javascriptreact = true,
					typescript = true,
					typescriptreact = true,
					vue = true,
					rust = true,
					go = true,
				}

				if
					client:supports_method("textDocument/documentHighlight")
					and highlight_filetypes[vim.bo[bufnr].filetype]
				then
					local group = vim.api.nvim_create_augroup("UserLspDocumentHighlight", { clear = false })
					vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						group = group,
						buffer = bufnr,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						group = group,
						buffer = bufnr,
						callback = vim.lsp.buf.clear_references,
					})
				end

				if client:supports_method("textDocument/inlayHint") then
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end
				if client:supports_method("textDocument/codeLens") then
					vim.lsp.codelens.enable(true, { bufnr = bufnr })
				end
				if client:supports_method("textDocument/inlineCompletion") then
					vim.lsp.inline_completion.enable(true, { client_id = client.id })
				end
				if client:supports_method("textDocument/linkedEditingRange") then
					vim.lsp.linked_editing_range.enable(true, { client_id = client.id })
				end

				if client.name ~= "render-markdown" then
					vim.notify_once(client.name .. " ready", vim.log.levels.INFO, { title = "LSP" })
				end
			end,
		})

		require("mason-tool-installer").setup({
			ensure_installed = {
				"stylua",
				"black",
				"clang-format",
				"google-java-format",
				"sql-formatter",
				"prettier",
			},
			auto_update = false,
			run_on_start = true,
		})
	end,
}
