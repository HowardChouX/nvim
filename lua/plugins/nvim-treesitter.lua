-- 告诉 Lua 语言服务器 vim 是全局变量
---@diagnostic disable: undefined-global
return {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    --event = {"BufReadPost","BufNewFile"},
    build = ":TSUpdate",
    opts = {
        ensure_installed = {
            "lua",
            "toml",
            "python",
            "cpp",        -- C++
            "c",          -- C
            "json",
            "yaml",
            "bash",
            "markdown",
            "html",
            "css",
            "javascript",
            "typescript",
            "tsx",
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true, -- 启用 Treesitter 缩进，提供更精准的缩进体验
        },
    },
}

