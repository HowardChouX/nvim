-- ACP 权限模式工具 https://agentclientprotocol.com/protocol/session-config-options
-- =========================== 模块说明 ===========================
-- CodeCompanion 的 ACP 会话会通过 session_config_option 暴露一个 category == "mode"
-- 的 select 配置项。以 Claude Code (claude-agent-acp) 为例，其值为:
--   default(Manual) / acceptEdits(Accept edits) / plan(Plan) / auto(Auto)
--   / bypassPermissions(Bypass permissions，是否出现取决于 agent 的 ALLOW_BYPASS)
--
-- 本模块集中处理该选项的读取与切换，供两处复用:
--   1. lua/plugins/codecompanion.lua 的 <S-Tab> 循环切换键位
--   2. lua/plugins/lualine.lua 的常驻模式指示器
--
-- 注意: 不读取 User CodeCompanionChatACPConfigChanged 事件携带的 payload。
-- 该事件的 config_options[].name 恒为 nil (上游在 config options 就绪前就缓存了
-- 名称映射，见 interactions/chat/init.lua 的 _acp_name_map_cache)，因此名称一律
-- 在此处从展平后的选项列表反查。
-- =========================== 模块开始 ============================

local M = {}

---各模式的状态栏徽标样式
---使用紧凑标签和 Nerd Font 图标；未知模式回退到 agent 返回的名称。
---@type table<string, { label: string, icon: string, fg: string, bg: string }>
M.display = {
    default = { label = "ASK", icon = "", fg = "#7aa2f7", bg = "#1f2335" },
    acceptEdits = { label = "EDIT", icon = "", fg = "#e0af68", bg = "#29243a" },
    plan = { label = "PLAN", icon = "", fg = "#7dcfff", bg = "#1f2b3d" },
    auto = { label = "AUTO", icon = "", fg = "#9ece6a", bg = "#20303b" },
    bypassPermissions = { label = "BYPASS", icon = "", fg = "#f7768e", bg = "#3b2230" },
}

---循环切换时跳过的模式
---保留为空，让 Shift+Tab 可以切换到 bypassPermissions。
---@type table<string, boolean>
M.skip_in_cycle = {}

---解析聊天对象
---接受 Chat 对象、buffer 号，或省略(自动查找活跃的 ACP 会话)
---刻意通过 package.loaded 判断 codecompanion 是否已加载，避免状态栏热路径
---触发插件的提前加载 (插件是 VeryLazy 的)
---@param chat CodeCompanion.Chat|integer|nil
---@return CodeCompanion.Chat|nil
function M.resolve_chat(chat)
    if type(chat) == "table" and chat.acp_connection then
        return chat
    end

    local cc = package.loaded["codecompanion"]
    if not cc then
        return nil
    end

    if type(chat) == "number" then
        -- buf_get_chat 对 HTTP 适配器的 chat 也会返回对象 (只是没有 acp_connection)，
        -- 这里必须一并校验，否则调用方拿到一个没有 ACP 连接的 chat 会在下游索引 nil
        local c = cc.buf_get_chat(chat)
        return (c and c.acp_connection) and c or nil
    end

    -- 优先当前缓冲区，其次任意一个仍活着的 ACP 会话
    local cur = cc.buf_get_chat(vim.api.nvim_get_current_buf())
    if cur and cur.acp_connection then
        return cur
    end
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) then
            local c = cc.buf_get_chat(bufnr)
            if c and c.acp_connection then
                return c
            end
        end
    end
end

---@class CodeCompanion.ACPMode
---@field id string 配置项 id (通常即 "mode")
---@field value string 当前模式 id，如 "acceptEdits"
---@field name string 当前模式展示名，如 "Accept edits"
---@field options table[] 全部可选项，已展平

---读取当前 ACP 权限模式
---@param chat CodeCompanion.Chat|integer|nil 省略时自动查找活跃的 ACP 会话
---@return CodeCompanion.ACPMode|nil mode
---@return string|nil err
function M.get(chat)
    local c = M.resolve_chat(chat)
    if not c then
        return nil, "当前没有活跃的 ACP 会话"
    end

    local acp = require("codecompanion.acp")
    for _, opt in ipairs(c.acp_connection:get_config_options()) do
        if opt.category == "mode" and opt.type == "select" then
            -- 会话刚建立时 agent 可能还没给出当前值。此时若继续会渲染出 "ACP nil"，
            -- 所以明确报错而不是返回一个 value 为空的 table
            if opt.currentValue == nil then
                return nil, "ACP mode 尚未初始化"
            end

            local values = acp.flatten_config_options(opt.options or {})

            -- 反查展示名；查不到就退回 value id
            local name = opt.currentValue
            for _, v in ipairs(values) do
                if v.value == opt.currentValue then
                    name = v.name or v.value
                    break
                end
            end

            return {
                id = opt.id,
                value = opt.currentValue,
                name = name,
                options = values,
            }
        end
    end

    return nil, "该 adapter 未暴露 mode 选项"
end

---循环切换到下一个模式 (末尾回到开头)
---@param chat CodeCompanion.Chat|integer|nil
---@return CodeCompanion.ACPMode|nil mode 切换后的模式
---@return string|nil err
function M.cycle(chat)
    local c = M.resolve_chat(chat)
    if not c then
        return nil, "当前没有活跃的 ACP 会话"
    end

    local mode, err = M.get(c)
    if not mode then
        return nil, err
    end

    local values = mode.options
    if #values == 0 then
        return nil, "mode 没有可选值"
    end

    -- 定位当前值。idx 初始为 0: 万一 currentValue 不在列表内 (例如 agent 切模型后
    -- 把 mode 改成了列表外的值)，视为从头开始
    local idx = 0
    for i, v in ipairs(values) do
        if v.value == mode.value then
            idx = i
            break
        end
    end

    -- 往后找第一个未被跳过的模式。最多绕一圈，找不到就报错而不是死循环
    local next_val
    for step = 1, #values do
        local candidate = values[(idx + step - 1) % #values + 1]
        if not M.skip_in_cycle[candidate.value] then
            next_val = candidate
            break
        end
    end
    if not next_val then
        return nil, "没有可切换的 mode"
    end

    if not c.acp_connection:set_config_option(mode.id, next_val.value) then
        return nil, "切换 ACP mode 失败"
    end

    return {
        id = mode.id,
        value = next_val.value,
        name = next_val.name or next_val.value,
    }
end

---渲染紧凑的图标与模式标签
---无 ACP 会话时返回空串，组件自动不占位
---@param chat CodeCompanion.Chat|integer|nil 省略时自动解析
---@return string
function M.render(chat)
    local mode = M.get(chat)
    if not mode then
        return ""
    end

    local style = M.display[mode.value]
    if not style then
        return "󰒃 " .. mode.name
    end

    return string.format("%s %s", style.icon, style.label)
end

---返回当前模式的徽标颜色
---@return { fg: string, bg: string, gui: string }|nil
function M.lualine_color()
    local mode = M.get()
    local style = mode and M.display[mode.value]
    if not style then
        return nil
    end

    return { fg = style.fg, bg = style.bg, gui = "bold" }
end

---lualine 组件入口
---注意: lualine 对函数组件是以 (component, is_focused) 调用的
---(见 lualine/components/special/function_component.lua)，这里刻意显式忽略这些参数，
---不去猜测传入的第一个表是什么，始终自动解析当前会话
---@return string
function M.lualine()
    return M.render()
end

return M
