-- 告诉 Lua 语言服务器 vim 是全局变量
---@diagnostic disable: undefined-global

return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			-- snacks.nvim 基础配置
		},
	},
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		cmd = {
			"ClaudeCode",
			"ClaudeCodeFocus",
			"ClaudeCodeAdd",
			"ClaudeCodeSend",
			"ClaudeCodeDiffAccept",
			"ClaudeCodeDiffDeny",
			"ClaudeCodeStatus",
		},
		keys = {
			{ "<leader>t", "<cmd>ClaudeCode<cr>", desc = "切换 Claude Code (Toggle)", mode = { "n", "t" } },
			{ "g2", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Claude Code 接受更改" },
			{ "g3", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Claude Code 拒绝更改" },
		},
		opts = {
			terminal = {
				provider = "snacks", -- 使用 snacks.nvim 实现浮动窗口
				snacks_win_opts = {
					position = "float",
					width = 0.8,
					height = 0.8,
					border = "rounded",
				},
			},
		},
	},
}
