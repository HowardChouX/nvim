-- 告诉 Lua 语言服务器 vim 是全局变量
---@diagnostic disable: undefined-global

local function delete_buffer(bufnr)
    bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr

    if vim.bo[bufnr].modified then
        vim.notify("缓冲区存在未保存的修改", vim.log.levels.WARN)
        return
    end

    local ok, err = pcall(vim.api.nvim_buf_delete, bufnr, { force = false })
    if not ok then
        vim.notify(tostring(err), vim.log.levels.ERROR)
    end
end

return {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    keys = {
        { "<leader>bh", "<Cmd>BufferLineCyclePrev<CR>", desc = "上一个缓冲区" },
        { "<leader>bl", "<Cmd>BufferLineCycleNext<CR>", desc = "下一个缓冲区" },
        { "<leader>bp", "<Cmd>BufferLinePickClose<CR>", desc = "选择关闭缓冲区" },
        { "<leader>bc", "<Cmd>BufferLineCloseOthers<CR>", desc = "关闭其他缓冲区" },
        { "<leader>bd", function() delete_buffer(0) end, desc = "关闭当前缓冲区" },
    },

    opts = {
        options = {
            diagnostics = "nvim_lsp",
            diagnostics_indicator = function(count, level)
                local icons = {
                    error = "",
                    warning = "",
                    info = "",
                    hint = "󰌶",
                }

                return string.format(" %s %d", icons[level] or "", count)
            end,
            close_command = delete_buffer,
            right_mouse_command = delete_buffer,
        },
    },
}
