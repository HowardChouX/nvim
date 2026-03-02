-- Input Method (IME) 配置
-- 解决 RIME 输入法在 nvim 中的问题
-- 自动在 Normal 模式切换到英文，Insert 模式保持中文

local M = {}
local is_enabled = vim.fn.executable("fcitx5-remote") == 1

-- 获取当前输入法状态
local function get_ime_status()
  if not is_enabled then
    return -1
  end
  local handle = io.popen("fcitx5-remote 2>/dev/null")
  if not handle then
    return -1
  end
  local status = handle:read("*a")
  handle:close()
  return tonumber(status) or -1
end

-- 退出输入法（切换到英文）
local function deactivate_ime()
  if is_enabled then
    os.execute("fcitx5-remote -c 2>/dev/null")
  end
end

-- 激活输入法（切换到中文）
local function activate_ime()
  if is_enabled then
    os.execute("fcitx5-remote -o 2>/dev/null")
  end
end

-- 切换输入法状态
local function toggle_ime()
  if is_enabled then
    os.execute("fcitx5-remote -t 2>/dev/null")
  end
end

function M.setup()
  -- 配置状态
  M.auto_switch = true  -- 自动切换开关

  -- Insert Leave: 退出插入模式时切换到英文
  vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
      if M.auto_switch then
        deactivate_ime()
      end
    end,
  })

  -- Insert Enter: 进入插入模式时保持当前输入法状态
  -- 用户可以根据需要手动切换
  vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    callback = function()
      -- 可选：进入插入模式时自动切换到中文
      -- activate_ime()
    end,
  })

  -- 使用 Ctrl+Space 手动切换（在插入模式生效）
  vim.api.nvim_set_keymap("i", "<C-Space>", "<Cmd>lua require('core.ime').toggle()<CR>", {
    noremap = true,
    silent = true,
    desc = "Toggle IME"
  })

  -- 使用 Ctrl+` 快速退出输入法（在插入模式）
  vim.api.nvim_set_keymap("i", "<C-`>", "<Cmd>lua require('core.ime').deactivate()<CR>", {
    noremap = true,
    silent = true,
    desc = "Deactivate IME"
  })

  -- 状态栏显示
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
      local status = get_ime_status()
      if status == 1 then
        vim.g.ime_status = "中"
      elseif status == 0 then
        vim.g.ime_status = "英"
      else
        vim.g.ime_status = ""
      end
    end,
  })

  -- 设置状态栏
  vim.opt.statusline = vim.opt.statusline .. [[%#IMEStatus# %{get(g:, 'ime_status', '')} %*]]

  print("IME 配置已加载: InsertLeave 自动切换英文, Ctrl+Space 切换中/英")
end

-- 切换输入法
function M.toggle()
  toggle_ime()
  vim.defer_fn(function()
    local status = get_ime_status()
    if status == 1 then
      vim.notify("中文输入已开启", vim.log.levels.INFO)
    elseif status == 0 then
      vim.notify("英文输入已开启", vim.log.levels.INFO)
    end
  end, 50)
end

-- 退出输入法（英文）
function M.deactivate()
  deactivate_ime()
  vim.notify("英文输入已开启", vim.log.levels.INFO)
end

-- 激活输入法（中文）
function M.activate()
  activate_ime()
  vim.notify("中文输入已开启", vim.log.levels.INFO)
end

-- 启用/禁用自动切换
function M.enable_auto()
  M.auto_switch = true
  vim.notify("IME 自动切换已启用", vim.log.levels.INFO)
end

function M.disable_auto()
  M.auto_switch = false
  vim.notify("IME 自动切换已禁用", vim.log.levels.INFO)
end

return M