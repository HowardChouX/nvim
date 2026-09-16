-- 告诉 Lua 语言服务器 vim 是全局变量
---@diagnostic disable: undefined-global
-- 注意：本插件已锁定 main 分支，main 分支移除了 master 的
-- ensure_installed / auto_install / highlight / indent 等配置项，
-- 改为用 install() 安装解析器 + FileType autocmd 手动启用高亮与缩进。
return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false, -- 必须早于文件打开时加载，否则首屏文件拿不到高亮
	build = ":TSUpdate",
	config = function()
		local parsers = {
			"lua",
			"vim",
			"vimdoc",
			"toml",
			"python",
			"cpp", -- C++
			"c", -- C
			"json",
			"yaml", -- CodeCompanion prompt library 解析 frontmatter 需要
			"bash",
			"markdown",
			"markdown_inline",
			"html",
			"css",
			"javascript",
			"typescript",
			"tsx",
			"regex",
			"go",
			"java",
			"rust",
			"query",
		}

		-- 已安装的会自动跳过，缺失的异步下载并编译
		require("nvim-treesitter").install(parsers)

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local buf = args.buf
				-- 没有对应解析器时 start 会报错，直接跳过
				if not pcall(vim.treesitter.start, buf) then
					return
				end
				-- 缩进由 nvim-treesitter 提供
				vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
