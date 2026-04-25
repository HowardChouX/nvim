---@diagnostic disable: undefined-global
return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"nvim-java/nvim-java",
	},
	config = function()
		local dap = require("dap")

		-- Java 调试配置
		dap.configurations.java = {
			{
				type = "java",
				request = "launch",
				name = "Debug (Launch)",
				javaExec = "/usr/lib/jvm/java-21-openjdk/bin/java",
				cwd = "${workspaceFolder}",
				stopOnEntry = true,
				console = "internalConsole",
				vmArgs = "-Xms128m -Xmx512m",
			},
			{
				type = "java",
				request = "attach",
				name = "Debug (Attach)",
				hostName = "localhost",
				port = 5005,
				cwd = "${workspaceFolder}",
			},
		}

		-- 断点图标
		vim.fn.sign_define("DapBreakpoint", {
			text = "🔴",
			texthl = "DiagnosticError",
			linehl = "",
			numhl = "",
		})
		vim.fn.sign_define("DapBreakpointCondition", {
			text = "🟡",
			texthl = "DiagnosticWarn",
			linehl = "",
			numhl = "",
		})
		vim.fn.sign_define("DapLogPoint", {
			text = "🔵",
			texthl = "DiagnosticInfo",
			linehl = "",
			numhl = "",
		})
		vim.fn.sign_define("DapStopped", {
			text = "▶️",
			texthl = "DiagnosticHint",
			linehl = "Visual",
			numhl = "",
		})
	end,
}
