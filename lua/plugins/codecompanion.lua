-- CodeCompanion.nvim - AI 编程助手
-- https://github.com/olimorris/codecompanion.nvim
---@diagnostic disable: undefined-global

return {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "lalitmee/codecompanion-spinners.nvim",
        {
            "HakonHarnes/img-clip.nvim",
            opts = {
                default = {
                    dir_path = vim.fn.stdpath("data") .. "/codecompanion/images",
                },
                filetypes = {
                    codecompanion = {
                        prompt_for_file_name = false,
                        template = "[Image]($FILE_PATH)",
                        use_absolute_path = true,
                    },
                },
            },
            init = function()
                local group = vim.api.nvim_create_augroup("codecompanion_image_paste", { clear = true })

                vim.api.nvim_create_autocmd("FileType", {
                    desc = "CodeCompanion 聊天缓冲区图片粘贴支持",
                    group = group,
                    pattern = "codecompanion",
                    callback = function(ev)
                        vim.keymap.set({ "n", "i" }, "<C-v>", "<Cmd>PasteImage<CR>", {
                            buffer = ev.buf,
                            desc = "[CodeCompanion] 粘贴剪贴板图片",
                        })
                    end,
                })
            end,
        },
    },

    opts = {
        display = {
            chat = {
                fold_context = true,
                show_reasoning = false,
                intro_message = "欢迎使用 CodeCompanion ✨！按 ? 查看选项",
                icons = {
                    chat_context = " ",
                },
                window = {
                    width = 0.4,
                    opts = {
                        number = false,
                        relativenumber = false,
                        signcolumn = "no",
                        cursorline = true,
                        winbar = "",
                    },
                },
            },
        },

        interactions = {
            background = {
                adapter = "claude_code",
                chat = {
                    opts = {
                        enabled = true,
                    },
                },
            },

            chat = {
                adapter = "claude_code",
                roles = {
                    llm = "CodeCompanion",
                },
                keymaps = {
                    -- 这两个快捷键只控制 CodeCompanion 内置工具，不控制 ACP 权限。
                    clear_approvals = false,
                    yolo_mode = false,
                    cycle_acp_mode = {
                        modes = { n = "<S-Tab>" },
                        description = "[Agent] 循环切换 ACP 权限模式",
                        callback = function(chat)
                            local acp_mode = require("plugins.codecompanion.acp_mode")
                            local mode, err = acp_mode.cycle(chat)
                            if not mode then
                                return vim.notify(err, vim.log.levels.WARN)
                            end

                            vim.notify("ACP Mode → " .. mode.name, vim.log.levels.INFO)
                            if chat.update_metadata then
                                chat:update_metadata()
                            end
                        end,
                    },
                },
            },

            inline = {
                adapter = "claude_code",
            },

            cmd = {
                adapter = "claude_code",
            },
        },

        extensions = {
            spinner = {
                enabled = true,
                opts = {
                    style = "lualine",
                },
            },
        },

        -- Claude Code 会自行加载 CLAUDE.md/AGENTS.md，避免重复注入上下文。
        rules = {
            opts = {
                chat = {
                    autoload = false,
                },
            },
        },

        adapters = {
            http = {
                opts = {
                    show_presets = false,
                },
            },

            -- ACP: Agent Client Protocol
            acp = {
                opts = {
                    show_presets = false,
                },
                claude_code = function()
                    return require("codecompanion.adapters").extend("claude_code", {})
                end,
            },
        },

        opts = {
            log_level = "INFO",
            language = "简体中文",
        },
    },
}
