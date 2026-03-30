---@diagnostic disable: undefined-global
return {
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope", -- cmd Telescope` 懒加载
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
        },
        opts = {
            defaults = {
                sorting_strategy = "ascending",
                layout_config = {
                    prompt_position = "top",
                },
                -- 移除不正确的sorter配置，使用默认值
            },
            -- 为 ui-select 扩展配置主题，可选
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown {
                        layout_strategy = "center",
                        layout_config = {
                            mirror = true,
                        },
                    }
                }
            }
        },
        config = function(_, opts)
            local telescope = require("telescope")
            local entry_display = require("telescope.pickers.entry_display")

            -- 自定义 entry_maker 用于 keymaps，实现按 desc (频率) 排序
            local keymap_displayer = entry_display.create({
                separator = " ▏",
                items = {
                    { width = 4 },        -- Mode
                    { width = 15 },       -- Key
                    { remaining = true }, -- Desc
                },
            })

            local function make_keymap_display(entry)
                local lhs = entry.value.lhs
                if lhs == " " then lhs = "<Space>" end

                return keymap_displayer({
                    { entry.value.mode,                          "TelescopeResultsIdentifier" },
                    { lhs,                                       "TelescopeResultsNumber" },
                    { entry.value.desc or entry.value.rhs or "", "TelescopeResultsComment" },
                })
            end

            local function keymap_entry_maker(line)
                -- line 是 nvim_get_keymap 返回的原生表
                local lhs = line.lhs
                if lhs == " " then lhs = "<Space>" end

                -- 过滤掉内部插件映射 (<Plug>) 和无用的默认映射
                if lhs:lower():find("<plug>") then
                    return nil
                end

                -- 核心过滤规则：
                -- 1. 必须有描述 (desc)
                -- 2. 描述中必须包含中文字符 ([\u4e00-\u9fa5])
                -- 这样可以完美过滤掉所有插件自动生成的英文快捷键、命令行命令等
                if not line.desc or line.desc == "" or not line.desc:match("[\228-\233][\128-\191][\128-\191]") then
                    return nil
                end

                -- 特殊处理：如果是搜索 F9 等，不要只匹配 desc，也要匹配 lhs (按键本身)
                -- ordinal 决定了搜索时匹配的内容
                return {
                    value = line,
                    display = make_keymap_display,
                    ordinal = line.desc .. " " .. lhs, -- 确保搜索 "f9" 时能匹配到 lhs 为 <F9> 的项
                }
            end

            -- 注入到 pickers 配置中
            opts.pickers = vim.tbl_deep_extend("force", opts.pickers or {}, {
                keymaps = {
                    entry_maker = keymap_entry_maker,
                    -- 移除 tiebreak，使用 Telescope 默认的评分排序机制
                },
            })

            telescope.setup(opts)

            -- 加载 ui-select 扩展，使得 vim.ui.select 使用 Telescope 界面
            require("telescope").load_extension("ui-select")
        end,
    },
}

