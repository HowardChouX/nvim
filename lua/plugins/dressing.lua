-- Tell Lua language server that vim is a global variable
---@diagnostic disable: undefined-global

return {
    {
        "stevearc/dressing.nvim",
        enabled = true,
        event = "VeryLazy",
        config = function()
            require("dressing").setup({
                input = {
                    -- 设置输入框相关配置
                    enabled = true,
                    default_prompt = "Input:",
                    prompt_align = "left",
                    insert_only = true,
                    anchor = "SW",
                    relative = "cursor",
                    prefer_width = 40,
                    max_width = 80,
                    min_width = 20,
                    border = "rounded",
                    -- 处理隐藏输入 (密码) 的情况
                    win_options = {
                        winblend = 0,
                        wrap = false,
                    },
                },
                select = {
                    -- 设置选择框相关配置
                    enabled = true,
                    backend = "telescope",
                    telescope = require('telescope.themes').get_cursor({
                        layout_config = {
                            width = 80,
                            height = 20,
                        },
                    }),
                },
            })
        end,
    },
}