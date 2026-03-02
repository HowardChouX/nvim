-- 告诉 Lua 语言服务器 vim 是全局变量
---@diagnostic disable: undefined-global
-- ~/.config/nvim/lua/neovide_config.lua

-- 只有在 Neovide 运行时才应用这些设置
if vim.g.neovide then
    -- 启用全屏模式 (默认启动时全屏)
    vim.g.neovide_fullscreen = true
    -- 启用无边框模式
    vim.g.neovide_no_border = true

    -- 窗口透明度 (0.0 完全透明, 1.0 完全不透明)
    -- 注意: neovide_transparency 已弃用，请使用 neovide_opacity
    -- 你的原始值是 0.9，这里也设置为 0.9 (表示不透明)
    vim.g.neovide_opacity = 0.95

    -- 光标动画速度 (值越小动画越快，0.05 是一个比较流畅的值)
    vim.g.neovide_cursor_animation_length = 0.04
    -- 界面缩放因子 (例如 1.0 是正常大小，1.2 是放大 20%)
    vim.g.neovide_scale_factor = 1.0


    -- 启用 Neovide 的内置字体渲染 (通常效果更好，推荐开启)
    vim.g.neovide_no_multigrid = true

    -- 启用 Neovide 的内置模糊效果 (如果需要，值越大模糊越强)
    -- vim.g.neovide_transparency_blur_amount = 10

    -- 设置 Neovide 窗口的初始大小 (例如 "80x24" 或 "120x30")
    vim.g.neovide_remember_window_size = true -- 记住上次窗口大小
    vim.g.neovide_window_size = "120x30"     -- 设置特定初始大小

    -- 启用 Neovide 的动画效果 (例如滚动动画)
    vim.g.neovide_scroll_animation_length = 0.1

    -- 设置 Neovide 的字体 (例如 "JetBrainsMono Nerd Font:h12")
    vim.g.neovide_font_family = "JetBrainsMono Nerd Font"
    vim.g.neovide_font_size = 14
    vim.o.guifont = "JetBrainsMono Nerd Font:h14"

    -- 设置 fallback 字体以确保所有符号正确显示
    vim.o.guifontset = "JetBrainsMono Nerd Font:h14,Symbols Nerd Font:h14"

    -- 启用 Neovide 的内置字体渲染 (通常效果更好，推荐开启)
    vim.g.neovide_no_multigrid = true

    -- 启用 Neovide 的浮动窗口阴影
    vim.g.neovide_floating_blur = true

    -- 启用 Neovide 的浮动窗口阴影
    vim.g.neovide_floating_blur = true
end
