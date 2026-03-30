-- 告诉 Lua 语言服务器 vim 是全局变量
---@diagnostic disable: undefined-global
return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	opts = {},
}
