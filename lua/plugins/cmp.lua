-- lua/plugins/cmp.lua
-- 告诉 Lua 语言服务器 vim 是全局变量
---@diagnostic disable: undefined-global
return {
  "hrsh7th/nvim-cmp",
  event = "VeryLazy", -- 必须在VeryLazy及前加载否则cmd异常
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "onsails/lspkind.nvim", -- 为补全项添加图标
    "lukas-reineke/cmp-under-comparator", -- 用于排序
  },
  config = function()
    local cmp = require("cmp")
    local lspkind = require("lspkind")
    -- 确保 cmp_nvim_lsp 已正确加载
    local has_cmp_lsp = pcall(require, "cmp_nvim_lsp")
    if not has_cmp_lsp then
      vim.notify("cmp_nvim_lsp 插件未找到，请确保已安装", vim.log.levels.ERROR)
    end
    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- 自动选择第一个选项
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip", priority = 750 },
        { name = "buffer", priority = 500, keyword_length = 2 },
        { name = "path", priority = 250 },
      }),
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text",
          maxwidth = 50,
          ellipsis_char = "...",
          before = function(entry, vim_item)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        }),
      },
      sorting = {
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          require("cmp-under-comparator").under,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
    })
    -- 配置命令行补全
    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" }
      }
    })
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
        { name = "cmdline" }
      })
    })
  end,
}
